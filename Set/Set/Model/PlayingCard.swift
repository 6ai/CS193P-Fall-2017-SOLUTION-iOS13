//
// Created by nattle on 06/03/2020.
// Copyright (c) 2020 Annette. All rights reserved.
//

import UIKit

struct PlayingCard {
    let color:   UIColor
    let shape:   Shape
    let number:  Number
    let shading: Shading

    enum Shape: CaseIterable {
        case oval, diamond, squiggle
    }

    enum Shading: CaseIterable {
        case solid, stripe, empty
    }

    enum Number: CaseIterable {
        case one, two, three
    }

}

extension PlayingCard: Hashable {

    func hash(into hasher: inout Hasher) {
        hasher.combine(color)
        hasher.combine(shape)
        hasher.combine(number)
        hasher.combine(shading)
    }

    static func ==(lhs: PlayingCard, rhs: PlayingCard) -> Bool {
        if lhs.color != rhs.color {
            return false
        }
        if lhs.shape != rhs.shape {
            return false
        }
        if lhs.number != rhs.number {
            return false
        }
        if lhs.shading != rhs.shading {
            return false
        }
        return true
    }
}