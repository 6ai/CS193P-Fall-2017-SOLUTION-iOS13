//
// Created by yasuhiko2 on 03/04/2020.
// Copyright (c) 2020 yasuhiko2. All rights reserved.
//

import Foundation

class Concentration {
    private(set) var cards: [Card]
    private(set) var score = 0
    private var indexOfChosenCard: Int?

    init(numberOfCards: Int, emojiChoice: [String]) {
        cards = []
        for index in 0..<numberOfCards {
            let card = Card(emoji: emojiChoice[index])
            cards += [card, card]
        }
        cards.shuffle()
    }

    func chooseCard(at index: Int) {
        guard index < cards.count else {
            return
        }
        cards[index].isFaceUp = true

        if let indexOfFaceUpCard = indexOfChosenCard, indexOfFaceUpCard != index {
            if cards[index].emoji == cards[indexOfFaceUpCard].emoji {
                cards[index].isMatched = true
                cards[indexOfFaceUpCard].isMatched = true
                indexOfChosenCard = nil
                score += 2
            } else {
                cards[indexOfFaceUpCard].isFaceUp = false
                indexOfChosenCard = index
                score -= 1
            }
        } else {
            indexOfChosenCard = index
        }
    }
}
