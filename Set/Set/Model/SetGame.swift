//
//  Created by yasuhiko2 on 04/03/2020.
//  Copyright © 2020 yasuhiko2. All rights reserved.
//

import Foundation

struct SetGame {

    private(set) var deck = SetDeck()
    private(set) var matchedCount = 0
    private(set) var cardOnHands: [SetCard] = []
    private(set) var cardOnTable: [SetCard] = []
    private(set) var lastMatchedCard: [SetCard] = []
    private(set) var lastAddedCard: [SetCard] = []

    init() {
        deck.shuffle()
        cardOnTable = deck.draw(countOfCards: 12)!
        lastAddedCard = cardOnTable
    }

    func isChosenCardsContainsSet() -> Bool {
        guard cardOnHands.count == 3 else {
            return false
        }
        return true // debug return todo remove

        let colors: Set = [cardOnHands.map {
            $0.color
        }]
        let shapes: Set = [cardOnHands.map {
            $0.shape
        }]
        let numbers: Set = [cardOnHands.map {
            $0.number
        }]
        let shadings: Set = [cardOnHands.map {
            $0.shading
        }]

        return colors.count != 2 && shapes.count != 2 && numbers.count != 2 && shadings.count != 2
    }

    mutating func addCardsOnTable(countOfCards: Int) {
        guard let drawCards = deck.draw(countOfCards: countOfCards) else {
            lastAddedCard.removeAll(); return }
        lastAddedCard = drawCards
        cardOnTable = cardOnTable + drawCards
    }

    mutating func reshuffleCardsOnTable() {
        cardOnTable.shuffle()
    }

    mutating func clearTableFromTakenCards() {
        lastAddedCard.removeAll()
        for card in cardOnHands {
            if let cardIndexOnTable = cardOnTable.firstIndex(of: card) {
                if let drawCards = deck.draw(countOfCards: 1) {
                    cardOnTable[cardIndexOnTable] = drawCards[0]
                    lastAddedCard.append(cardOnTable[cardIndexOnTable])
                } else {
                    cardOnTable.remove(at: cardIndexOnTable)
                }
            }
        }
    }

    mutating func takeCardFromTable(card: SetCard) {
        guard cardOnTable.contains(card) else {
            return
        }
        lastAddedCard.removeAll()
        lastMatchedCard.removeAll()
        cardOnHands.append(card)
        if isChosenCardsContainsSet() {
            matchedCount += 1
            clearTableFromTakenCards()
            lastMatchedCard = cardOnHands
            cardOnHands.removeAll()
        }
    }

    mutating func discard(card: SetCard) {
        guard let indexOfCard = cardOnHands.firstIndex(of: card) else {
            return
        }
        lastAddedCard.removeAll()
        lastMatchedCard.removeAll()
        cardOnHands.remove(at: indexOfCard)
    }
}


