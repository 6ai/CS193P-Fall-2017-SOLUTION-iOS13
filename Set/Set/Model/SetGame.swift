//
// Created by nattle on 06/03/2020.
// Copyright (c) 2020 Annette. All rights reserved.
//

import Foundation

struct SetGame {

    private var deck = PlayingDeck()
    private(set) var matchedCount = 0
    private(set) var takenCards: [PlayingCard] = []
    private(set) var cardsOnTable: [PlayingCard] = []
    private(set) var lastMatchedCards: [PlayingCard] = []

    init() {
        deck.shuffle()
        cardsOnTable = deck.draw(countOfCards: 12)!
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
        guard let drawCards = deck.draw(countOfCards: countOfCards) else { return }
        cardsOnTable = cardsOnTable + drawCards
    }

    mutating func reshuffleCardsOnTable() {
        cardsOnTable.shuffle()
    }

    mutating func clearTableFromTakenCards() {
        for card in takenCards {
            if let cardIndexOnTable = cardsOnTable.firstIndex(of: card) {
                if let drawCards = deck.draw(countOfCards: 1) {
                    cardsOnTable[cardIndexOnTable] = drawCards[0]
                } else {
                    cardsOnTable.remove(at: cardIndexOnTable)
                }
            }
        }
    }

    mutating func takeCardFromTable(card: PlayingCard) {
        guard cardsOnTable.contains(card) else { return }
        takenCards.append(card)
        if isChosenCardsContainsSet() {
            matchedCount += 1
            clearTableFromTakenCards()
            lastMatchedCards = takenCards
            takenCards.removeAll()
        }
    }

    mutating func discardHandCard(card: PlayingCard) {
        guard let indexOfCard = takenCards.firstIndex(of: card) else { return }
        takenCards.remove(at: indexOfCard)
    }
}


