//
// Created by yasuhiko2 on 03/04/2020.
// Copyright (c) 2020 yasuhiko2. All rights reserved.
//

import Foundation

struct Card {
    var isMatched = false
    var isFaceUp = false
    var emoji: String
    private let identifier: Int = {
        getUniqueIdentifier()
    }()

    private static var currentNumberOfIdentifier = 0

    private static func getUniqueIdentifier() -> Int {
        currentNumberOfIdentifier += 1
        return currentNumberOfIdentifier
    }

    init(emoji: String) {
        self.emoji = emoji
    }
}
