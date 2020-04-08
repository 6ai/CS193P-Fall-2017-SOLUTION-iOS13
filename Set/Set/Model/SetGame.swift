//
//  Created by yasuhiko2 on 04/03/2020.
//  Copyright © 2020 yasuhiko2. All rights reserved.
//

struct SetGame {
    private(set) var matchedCount = 0

    private(set) var deck = SetDeck()
    private(set) var cardsOnHands: [SetCard] = []
    private(set) var cardOnTable: [SetCard] = []

    /*private(set)*/ var lastMatchedCard: [SetCard] = []
    /*private(set)*/ var lastAddedCard: [SetCard] = []

    init() {
        deck.shuffle()
        cardOnTable = deck.draw(countOfCards: 12)!
        lastAddedCard = cardOnTable
    }

    func isChosenCardsContainsSet() -> Bool {
        guard cardsOnHands.count == 3 else {
            return false
        }

        let numberAmount = cardsOnHands.map {
            $0.number
        }.amountUniqueItems
        let colorAmount = cardsOnHands.map {
            $0.color
        }.amountUniqueItems
        let shadingAmount = cardsOnHands.map {
            $0.shading
        }.amountUniqueItems
        let shapeAmount = cardsOnHands.map {
            $0.shape
        }.amountUniqueItems

        return numberAmount != 2 && colorAmount != 2 && shapeAmount != 2 && shadingAmount != 2
    }

    mutating func addCardsOnTable(countOfCards: Int) {
        guard let drawCards = deck.draw(countOfCards: countOfCards) else {
            lastAddedCard.removeAll(); return
        }
        lastAddedCard = drawCards
        cardOnTable = cardOnTable + drawCards
    }

    mutating func reshuffleCardsOnTable() {
        cardOnTable.shuffle()
    }

    mutating func clearTableFromTakenCards() {
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
        cardsOnHands.remove(at: indexOfCard)
    }
}

extension Array where Element: Hashable {
    var amountUniqueItems: Int {
        Array(Set(self)).count
    }
}

