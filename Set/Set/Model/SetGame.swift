//
//  Created by yasuhiko2 on 04/03/2020.
//  Copyright © 2020 yasuhiko2. All rights reserved.
//

import Foundation

struct SetGame {

    private(set) var deck = SetDeck()
    private(set) var matchedCount = 0
    private(set) var takenCards: [SetCard] = []
    private(set) var cardsOnTable: [SetCard] = []
    private(set) var lastMatchedCards: [SetCard] = []
    private(set) var lastAddedCard: [SetCard] = []

    init() {
        deck.shuffle()
        cardsOnTable = deck.draw(countOfCards: 12)!
        lastAddedCard = cardsOnTable
    }

    func isChosenCardsContainsSet() -> Bool {
        guard takenCards.count == 3 else { return false }
        return true // debug return todo remove

        let colors: Set = [takenCards.map { $0.color }]
        let shapes: Set = [takenCards.map { $0.shape }]
        let numbers: Set = [takenCards.map { $0.number }]
        let shadings: Set = [takenCards.map { $0.shading }]

        return colors.count != 2 && shapes.count != 2 && numbers.count != 2 && shadings.count != 2
    }

    mutating func addCardsOnTable(countOfCards: Int) {
        guard let drawCards = deck.draw(countOfCards: countOfCards) else {
            lastAddedCard.removeAll(); return }
        lastAddedCard = drawCards
        cardsOnTable = cardsOnTable + drawCards
    }

    mutating func reshuffleCardsOnTable() {
        cardsOnTable.shuffle()
    }

    mutating func clearTableFromTakenCards() {
        lastAddedCard.removeAll()
        for card in takenCards {
            if let cardIndexOnTable = cardsOnTable.firstIndex(of: card) {
                if let drawCards = deck.draw(countOfCards: 1) {
                    cardsOnTable[cardIndexOnTable] = drawCards[0]
                    lastAddedCard.append(cardsOnTable[cardIndexOnTable])
                } else {
                    cardsOnTable.remove(at: cardIndexOnTable)
                }
            }
        }
    }

    mutating func takeCardFromTable(card: SetCard) {
        guard cardsOnTable.contains(card) else { return }
        lastAddedCard.removeAll()
        lastMatchedCards.removeAll()
        takenCards.append(card)
        if isChosenCardsContainsSet() {
            matchedCount += 1
            clearTableFromTakenCards()
            lastMatchedCards = takenCards
            takenCards.removeAll()
        }
    }

    mutating func discard(card: SetCard) {
        guard let indexOfCard = takenCards.firstIndex(of: card) else { return }
        lastAddedCard.removeAll()
        lastMatchedCards.removeAll()
        takenCards.remove(at: indexOfCard)
    }
}


