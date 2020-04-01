//
//  Created by yasuhiko2 on 04/03/2020.
//  Copyright © 2020 yasuhiko2. All rights reserved.
//

import UIKit

struct SetDeck {
    private var deck: [SetCard]

    init() {
        self.deck = []

        for color in SetCard.Color.allCases {
            for shape in SetCard.Shape.allCases {
                for shading in SetCard.Shading.allCases {
                    for number in SetCard.Number.allCases {
                        let card = SetCard(color: color, shape: shape, number: number, shading: shading)
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

    mutating func draw(countOfCards number: Int) -> [SetCard]? {
        guard number <= deck.count else {
            return nil
        }
        var drawCards: [SetCard] = []
        for _ in 1...number {
            drawCards.append(deck.popLast()!)
        }
        return drawCards
    }
}
