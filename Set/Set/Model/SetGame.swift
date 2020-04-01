//
//  Created by yasuhiko2 on 04/03/2020.
//  Copyright © 2020 yasuhiko2. All rights reserved.
//

import Foundation

struct SetGame {

    private(set) var deck = SetDeck()
    private(set) var matchedCount = 0
    private(set) var cardsOnHands: [SetCard] = []
    private(set) var cardOnTable: [SetCard] = []
    private(set) var lastMatchedCard: [SetCard] = []
    private(set) var lastAddedCard: [SetCard] = []

    init() {
        deck.shuffle()
        cardOnTable = deck.draw(countOfCards: 12)!
        lastAddedCard = cardOnTable
    }

    func isChosenCardsContainsSet() -> Bool {
        guard cardsOnHands.count == 3 else {
            return false
        }
        if (cardsOnHands.map {
            $0.color
        }.unique.count) == 2 {
            return false
        }

        if (cardsOnHands.map {
            $0.shape
        }.unique.count) == 2 {
            return false
        }

        if (cardsOnHands.map {
            $0.shading
        }.unique.count) == 2 {
            return false
        }

        if (cardsOnHands.map {
            $0.number
        }.unique.count) == 2 {
            return false
        }

        return true
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
        for card in cardsOnHands {
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
        cardsOnHands.append(card)
        lastAddedCard.removeAll()
        lastMatchedCard.removeAll()
        if cardsOnHands.count == 3 {
            if isChosenCardsContainsSet() {
                matchedCount += 1
                lastMatchedCard = cardsOnHands
                clearTableFromTakenCards()
            }
            cardsOnHands.removeAll()
        }
    }

    mutating func discard(card: SetCard) {
        guard let indexOfCard = cardsOnHands.firstIndex(of: card) else {
            return
        }
        lastAddedCard.removeAll()
        lastMatchedCard.removeAll()
        cardsOnHands.remove(at: indexOfCard)
    }
}

extension Array where Element: Hashable {
    var unique: [Element] {
        return Array(Set(self))
    }
}

