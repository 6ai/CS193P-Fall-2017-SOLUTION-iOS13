//
// Created by nattle on 06/03/2020.
// Copyright (c) 2020 Annette. All rights reserved.
//

import UIKit

struct Card {

    let color: Color
    let shape: Shape
    let number: Number
    let shading: Shading

    var description: String {
        "Card(color: \(color), figure: \(shape), quantity: \(number), shading: \(shading))"
    }

    init(color: Color, shape: Shape, number: Number, shading: Shading) {
        self.color = color
        self.shape = shape
        self.number = number
        self.shading = shading
    }
}

extension Card {

    enum Color: String {
        case green = "green"
        case red = "red"
        case purple = "purple"
        var description: String {
            rawValue
        }
        static let all = [Color.green, .red, .purple]

        func getUIColor() -> UIColor {
            switch self {
            case .green:
                return .green
            case .red:
                return .red
            case .purple:
                return .purple
            }
        }
    }

    enum Shape: String {
        case square = "■"
        case triangle = "▲"
        case circle = "●"
        var description: String {
            rawValue
        }
        static let all = [Shape.square, .triangle, .circle]

        func getShape() -> String {
            self.rawValue
        }
    }

    enum Shading: String {

        case solid = "solid"
        case stripe = "stripe"
        case empty = "empty"
        var description: String {
            rawValue
        }
        static let all = [Shading.solid, .stripe, .empty]

        func getAlpha() -> CGFloat {
            switch self {
            case .solid:
                return 1.0
            case .stripe:
                return 0.15
            case .empty:
                return 0.40
            }
        }
    }

    enum Number: Int {
        case one = 1
        case two = 2
        case three = 3
        var description: String {
            String(rawValue)
        }
        static let all = [Number.one, .two, .three]

        func getNumber() -> Int {
            self.rawValue
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