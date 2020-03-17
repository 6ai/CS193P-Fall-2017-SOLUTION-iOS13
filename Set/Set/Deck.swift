//
// Created by nattle on 12/03/2020.
// Copyright (c) 2020 nattle. All rights reserved.
//

import UIKit

struct Deck {
    private var deck: [Card]

    init() {
        self.deck = []
        let colors: [UIColor] = [.blue, .green, .purple]

        for color in colors {
            for shape in Card.Shape.allCases {
                for shading in Card.Shading.allCases {
                    for number in Card.Number.allCases {
                        let card = Card(color: color, shape: shape, number: number, shading: shading)
                        self.deck.append(card)
                    }
                }
            }
        }
    }

    mutating func reshuffle() {
        deck.shuffle()
    }

    mutating func draw(cardsEquals number: Int) -> [Card]? {
        guard number <= deck.count else { return nil }
        var cards = [Card]()
        for _ in 1...number { cards.append(deck.popLast()!) }
        return cards
    }
}