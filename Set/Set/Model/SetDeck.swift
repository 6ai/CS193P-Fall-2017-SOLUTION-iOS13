//
//  Created by yasuhiko2 on 04/03/2020.
//  Copyright © 2020 yasuhiko2. All rights reserved.
//

struct SetDeck {
    private var deck: [SetCard]

    init() {
        deck = []
        for color in SetCard.Color.allCases {
            for shape in SetCard.Shape.allCases {
                for shading in SetCard.Shading.allCases {
                    for number in SetCard.Number.allCases {
                        deck.append(SetCard(
                                color: color,
                                shape: shape,
                                number: number,
                                shading: shading
                        ))
                    }
                }
            }
        }
    }

    mutating func shuffle() {
        deck.shuffle()
    }

    func isEmpty() -> Bool {
        deck.isEmpty
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
