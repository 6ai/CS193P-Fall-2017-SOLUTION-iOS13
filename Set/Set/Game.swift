//
// Created by nattle on 06/03/2020.
// Copyright (c) 2020 Annette. All rights reserved.
//

import Foundation

struct Game {

    private var deck = Deck()
    private(set) var chosenCards = Set<Card>()
    private(set) var cardsOnTable = [Card]()
    private(set) var score = 0

    init() {
        deck.reshuffle()
        cardsOnTable = deck.draw(cardsEquals: 12)!
    }

    private func isChosenSet() -> Bool {
        return true
        guard chosenCards.count == 3 else { return false }

        let color   = Set(chosenCards.map { $0.color }).count
        let shape   = Set(chosenCards.map { $0.shape }).count
        let number  = Set(chosenCards.map { $0.number }).count
        let shading = Set(chosenCards.map { $0.shading }).count

        return color != 2 && shape != 2 && number != 2 && shading != 2
    }

    mutating func addCardsOnTable() {
        guard let drawCards = deck.draw(cardsEquals: 3) else { return }
        cardsOnTable = cardsOnTable + drawCards
    }

    mutating func reshuffleCardsOnTable() {
        cardsOnTable.shuffle()
    }

    mutating func chooseCard(card: Card) {
        assert(cardsOnTable.contains(card))
        chosenCards.insert(card)
        guard chosenCards.count == 3 else { return }
        if isChosenSet() {
            for card in chosenCards {
                if let cardIndexOnTable = cardsOnTable.firstIndex(of: card) {
                    if let drawCards = deck.draw(cardsEquals: 1) {
                        cardsOnTable[cardIndexOnTable] = drawCards[0]
                    } else {
                        cardsOnTable.remove(at: cardIndexOnTable)
                    }
                }
            }
            score += 5
        }
        chosenCards.removeAll()
    }

    mutating func disapproveCard(card: Card) {
        assert(chosenCards.contains(card))
        chosenCards.remove(card)
    }
}


