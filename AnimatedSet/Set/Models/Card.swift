//
//  Created by yasuhiko2 on 04/03/2020.
//  Copyright © 2020 yasuhiko2. All rights reserved.
//

import UIKit

struct Card: CustomStringConvertible {
    let color: Color
    let shape: Shape
    let number: Number
    let shading: Shading

    var description: String {
        "SetCard(color: \(color), shape: \(shape), number: \(number), shading: \(shading))"
    }
}

extension Card {
    enum Shape: CaseIterable {
        case oval, diamond, squiggle
    }

    enum Shading: CaseIterable {
        case solid, stripe, empty
    }

    enum Number: CaseIterable {
        case one, two, three

    }

    enum Color: CaseIterable {
        case variant1, variant2, variant3
        var rawValue: UIColor {
            switch self {
            case .variant1:
                return UIColor.red
            case .variant3:
                return UIColor.green
            case .variant2:
                return UIColor.blue
            }
        }
    }
}

extension Card: Hashable {

    func hash(into hasher: inout Hasher) {
        hasher.combine(color)
        hasher.combine(shape)
        hasher.combine(number)
        hasher.combine(shading)
    }

    static func ==(lhs: Card, rhs: Card) -> Bool {
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