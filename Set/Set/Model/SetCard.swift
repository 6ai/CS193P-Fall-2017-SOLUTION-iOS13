//
//  Created by yasuhiko2 on 04/03/2020.
//  Copyright © 2020 yasuhiko2. All rights reserved.
//

import UIKit

struct SetCard {
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

extension SetCard: Hashable {

    func hash(into hasher: inout Hasher) {
        hasher.combine(color)
        hasher.combine(shape)
        hasher.combine(number)
        hasher.combine(shading)
    }

    static func ==(lhs: SetCard, rhs: SetCard) -> Bool {
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