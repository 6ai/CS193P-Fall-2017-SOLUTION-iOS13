//
//  Created by yasuhiko2 on 04/03/2020.
//  Copyright © 2020 yasuhiko2. All rights reserved.
//

import UIKit

struct SetDeck {
    private var deck: [SetCard]

    init() {
        self.deck = []
        let cardColors: [UIColor] = [.red, .blue, .purple]

        for color in cardColors {
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
        var cards = [SetCard]()
        for _ in 1...number {
            cards.append(deck.popLast()!)
        }
        return cards
    }
}