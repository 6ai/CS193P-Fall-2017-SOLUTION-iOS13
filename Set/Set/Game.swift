//
// Created by nattle on 06/03/2020.
// Copyright (c) 2020 Annette. All rights reserved.
//

import Foundation

class Game {

    private(set) var deck = [Card]()
    private(set) var chosenCards = Set<Int>()
    private(set) var cardsOnTable = [Card?]()
    private(set) var score = 0

    init() {
        for color in Card.Color.all {
            for shape in Card.Shape.all {
                for shading in Card.Shading.all {
                    for number in Card.Number.all {
                        deck.append(Card(color: color, shape: shape,
                                number: number, shading: shading))
                    }
                }
            }
        }
        deck.shuffle()

        for _ in 1...4 {
            drawThreeCards()
        }
    }

    func isChosenSet() -> Bool {
        guard chosenCards.count == 3 else {
            return false
        }

        var cards = [Card]()
        for index in chosenCards {
            cards.append(cardsOnTable[index]!)
        }

        let color = Set(cards.map {
            $0.color
        }).count
        let shape = Set(cards.map {
            $0.shape
        }).count
        let number = Set(cards.map {
            $0.number
        }).count
        let shading = Set(cards.map {
            $0.shading
        }).count
        print("color: \(color), shape: \(shape), number: \(number),  shading: \(shading)")
        return color != 2 && shape != 2 && number != 2 && shading != 2
    }

    func drawThreeCards() {
        for _ in 1...3 {
            if let card = deck.popLast() {
                cardsOnTable.append(card)
            }
        }
    }


    func disapproveCard(at numberOfCard: Int) {
        // todo: rename func
        guard let index = chosenCards.firstIndex(of: numberOfCard) else {
            return
        }
        chosenCards.remove(at: index)
    }

    func chooseCard(at index: Int) {
        guard index < cardsOnTable.count else {
            return
        }
        chosenCards.insert(index)
        guard chosenCards.count == 3 else {
            return
        }
        if isChosenSet() {
            for index in chosenCards {
                score += 5
                cardsOnTable[index] = deck.popLast()
            }
        } else {
            score -= 3
        }
        chosenCards.removeAll()
    }
}
