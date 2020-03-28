//
//  PlayingCardView.swift
//  Set
//
//  Created by nattle on 10/03/2020.
//  Copyright © 2020 nattle. All rights reserved.
//

import UIKit

@IBDesignable
class PlayingCardView: UIView {
    var card: PlayingCard = PlayingCard(color: .green, shape: .squiggle, number: .three, shading: .stripe) {
        didSet {
            setNeedsDisplay(); setNeedsLayout()
        }
    }
    @IBInspectable
    var isFaceUp: Bool = true {
        didSet {
            setNeedsDisplay(); setNeedsLayout()
        }
    }

    public var border = false {
        didSet {
            switch border {
            case true:
                addBorder()
            case false:
                removeBorder()
            }
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)

        configure()

    }


    convenience init(frame: CGRect, card: PlayingCard) {
        self.init(frame: frame)
        self.card = card
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        if isFaceUp {
            addFigures()
        }

    }

    func addBorder() {
        layer.borderColor = Constants.borderColor
        layer.borderWidth = lineWidth * 2
    }

    func removeBorder() {
        layer.borderWidth = 0
    }

    private func configure() {
        backgroundColor = isFaceUp ? .white : .green
        layer.cornerRadius = cornerRadius
        layer.masksToBounds = true
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundColor = isFaceUp ? .white : .green
    }

    private func roundView() {
        let roundedRect = UIBezierPath(roundedRect: self.frame, cornerRadius: cornerRadius)
        Constants.cardColor.setFill()
        roundedRect.addClip()
        roundedRect.fill()
    }

    private func addFigures() {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        for (x, y) in coordinatesOfShapes {
            context.createFigurePath(figure: card.shape, scale: self.scale, translate: (x: x, y: y))
        }
        context.fillFigure(shading: card.shading, color: card.color, lineWidth: lineWidth)
    }
}

private extension PlayingCardView {
    private struct Constants {
        static let boundsHeight: CGFloat = 400
        static let boundsWidth:  CGFloat = 250
        static let scale:        CGFloat = 1.3
        static let cardColor:    UIColor = .white
        static let cornerRadius:    CGFloat = 0.08
        static let thirdOffset: CGFloat = 110
        static let offset:      CGFloat = 52
        static let borderColor: CGColor = UIColor.red.cgColor
    }

    private var lineWidth: CGFloat {
        return scale * 2
    }

    private var scale: CGFloat {
        return Constants.scale * bounds.size.height / Constants.boundsHeight
    }

    private var cornerRadius: CGFloat {
        return bounds.size.height * Constants.cornerRadius
    }

    private var coordinatesOfShapes: [(dx: CGFloat, dy: CGFloat)] {
        switch card.number {
        case .one:
            return [(bounds.midX, bounds.midY)]
        case .two:
            return [(bounds.midX, bounds.midY + Constants.offset * scale / 1.3),
                    (bounds.midX, bounds.midY - Constants.offset * scale / 1.3)]
        case .three:
            return [(bounds.midX, bounds.midY - Constants.thirdOffset * scale / 1.3),
                    (bounds.midX, bounds.midY),
                    (bounds.midX, bounds.midY + Constants.thirdOffset * scale / 1.3)]
        }
    }
}

// MARK: CGContext
extension CGContext {

    func fillFigure(shading: PlayingCard.Shading, color: UIColor, lineWidth: CGFloat) {
        switch shading {
        case .solid:
            color.setFill()
            self.fillPath()
        case .stripe:
            guard let path = self.path else { return }
            let outline = UIBezierPath(cgPath: path)
            self.addStripes()

            color.setStroke()
            self.setLineWidth(lineWidth /  2)
            self.strokePath()
            outline.lineWidth = lineWidth * 2
            outline.stroke()
        case .empty:
            color.setStroke()
            self.setLineWidth(lineWidth)
            self.strokePath()
        }
    }

    func createFigurePath(figure: PlayingCard.Shape, scale: CGFloat, translate: (x: CGFloat, y: CGFloat)) {
        // translate and scale the figure path
        self.saveGState()
        self.translateBy(x: translate.x, y: translate.y)
        self.scaleBy(x: scale, y: scale)

        // create figure path
        switch figure {
        case .diamond:
            self.createDiamondPath()
        case .oval:
            self.createOvalPath()
        case .squiggle:
            self.createSquigglePath()
        }
        self.restoreGState()
    }

    private func addStripes() {
        self.clip()
        let boundsHeight = 400
        let boundsWidth = 250
        for x in stride(from: 0, through: boundsWidth, by: 3) {
            self.move(to: CGPoint(x: x, y: 0))
            self.addLine(to: CGPoint(x: x, y: boundsHeight))
        }
    }

    private func createDiamondPath() {
        // create the squiggle path
        let leftCorner = CGPoint(x: -66, y: 2)
        let lowerCorner = CGPoint(x: 0, y: 34)
        let rightCorner = CGPoint(x: 66, y: 2)
        let upperCorner = CGPoint(x: 0, y: -30)

        self.move(to: leftCorner)
        self.addLine(to: upperCorner)
        self.addLine(to: rightCorner)
        self.addLine(to: lowerCorner)
        self.closePath()
    }

    private func createSquigglePath() {
        // create the squiggle path
        self.move(to: CGPoint(x: (104.0 * 1.2 - 67), y: (15.0 * 1.2 - 44)))
        self.addCurve(to: CGPoint(x: (63.00 * 1.2 - 67), y: (54.0 * 1.2 - 44)), control1: CGPoint(x: (112.4 * 1.2 - 67), y: (36.9 * 1.2 - 44)), control2: CGPoint(x: (89.70 * 1.2 - 67), y: (60.8 * 1.2 - 44)))
        self.addCurve(to: CGPoint(x: (27.00 * 1.2 - 67), y: (53.0 * 1.2 - 44)), control1: CGPoint(x: (52.30 * 1.2 - 67), y: (51.3 * 1.2 - 44)), control2: CGPoint(x: (42.20 * 1.2 - 67), y: (42.0 * 1.2 - 44)))
        self.addCurve(to: CGPoint(x: (5.000 * 1.2 - 67), y: (40.0 * 1.2 - 44)), control1: CGPoint(x: (9.600 * 1.2 - 67), y: (65.6 * 1.2 - 44)), control2: CGPoint(x: (5.400 * 1.2 - 67), y: (58.3 * 1.2 - 44)))
        self.addCurve(to: CGPoint(x: (36.00 * 1.2 - 67), y: (12.0 * 1.2 - 44)), control1: CGPoint(x: (4.600 * 1.2 - 67), y: (22.0 * 1.2 - 44)), control2: CGPoint(x: (19.10 * 1.2 - 67), y: (9.70 * 1.2 - 44)))
        self.addCurve(to: CGPoint(x: (89.00 * 1.2 - 67), y: (14.0 * 1.2 - 44)), control1: CGPoint(x: (59.20 * 1.2 - 67), y: (15.2 * 1.2 - 44)), control2: CGPoint(x: (61.90 * 1.2 - 67), y: (31.5 * 1.2 - 44)))
        self.addCurve(to: CGPoint(x: (104.0 * 1.2 - 67), y: (15.0 * 1.2 - 44)), control1: CGPoint(x: (95.30 * 1.2 - 67), y: (10.0 * 1.2 - 44)), control2: CGPoint(x: (100.9 * 1.2 - 67), y: (6.90 * 1.2 - 44)))

        self.setLineCap(.round)
    }

    private func createOvalPath() {
        // create the squiggle path
        self.move(to: CGPoint(x: -32, y: -28))
        self.addLine(to: CGPoint(x: 33, y: -28))
        self.addArc(center: CGPoint(x: 33, y: 1), radius: 29, startAngle: -CGFloat.pi / 2, endAngle: CGFloat.pi / 2, clockwise: false)
        self.addLine(to: CGPoint(x: -32, y: 30))
        self.addArc(center: CGPoint(x: -32, y: 1), radius: 29, startAngle: CGFloat.pi / 2, endAngle: CGFloat.pi / 2 * 3, clockwise: false)
    }
}
