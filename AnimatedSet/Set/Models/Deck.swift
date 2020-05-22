//
//  Created by yasuhiko2 on 04/03/2020.
//  Copyright © 2020 yasuhiko2. All rights reserved.
//

struct Deck {
    private var deck: [Card]

    init() {
        deck = []
        for color in Card.Color.allCases {
            for shape in Card.Shape.allCases {
                for shading in Card.Shading.allCases {
                    for number in Card.Number.allCases {
                        deck.append(Card(
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

    mutating func draw(countOfCards number: Int) -> [Card]? {
        guard number <= deck.count else {
            return nil
        }
        var drawCards: [Card] = []
        for _ in 1...number {
            drawCards.append(deck.popLast()!)
        }
        return drawCards
    }
}
