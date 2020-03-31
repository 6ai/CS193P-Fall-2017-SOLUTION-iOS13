//
// Created by nattle on 12/03/2020.
// Copyright (c) 2020 nattle. All rights reserved.
//

import UIKit

struct PlayingDeck {
    private var deck: [PlayingCard]

    init() {
        self.deck = []
        let cardColors: [UIColor] = [.purple/*, .blue, .purple*/]

        for color in cardColors {
            for shape in PlayingCard.Shape.allCases {
                for shading in PlayingCard.Shading.allCases {
                    for number in PlayingCard.Number.allCases {
                        let card = PlayingCard(color: color, shape: shape, number: number, shading: shading)
                        self.deck.append(card)
                    }
                }
            }
        }
    }

    mutating func shuffle() {
        deck.shuffle()
    }

    func isEmpty() -> Bool {
        return deck.isEmpty
    }

    mutating func draw(countOfCards number: Int) -> [PlayingCard]? {
        guard number <= deck.count else { return nil }
        var cards = [PlayingCard]()
        for _ in 1...number { cards.append(deck.popLast()!) }
        return cards
    }
}