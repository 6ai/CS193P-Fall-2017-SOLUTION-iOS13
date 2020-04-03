//
//  Created by yasuhiko2 on 04/03/2020.
//  Copyright © 2020 yasuhiko2. All rights reserved.
//


import UIKit

class SetCardView: UIView {
    var card: SetCard = SetCard(color: .variant1, shape: .squiggle, number: .three, shading: .stripe) {
        didSet {
            setNeedsDisplay(); setNeedsLayout()
        }
    }

    var isFaceUp: Bool = true {
        didSet {
            setNeedsDisplay(); setNeedsLayout()
        }
    }

    var isSelected: Bool = false {
        didSet {
            setNeedsDisplay(); setNeedsLayout()
        }
    }

    convenience init(frame: CGRect = .zero, card: SetCard) {
        self.init(frame: frame)
        self.card = card
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        guard let context = UIGraphicsGetCurrentContext(), isFaceUp else {
            return
        }

        layoutFigures(context: context)
    }

    private func layoutFigures(context: CGContext) {
        for (x, y) in coordinatesForShapesLayout {
            context.createFigurePath(figure: card.shape, scale: self.scale, translate: (x: x, y: y))
        }
        context.fillFigure(shading: card.shading, color: card.color.value, lineWidth: scaleLineWidth)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        configure()
    }

    private func configure() {
        backgroundColor = isFaceUp ? SizeRatioOfOriginSetCard.cardColor : SizeRatioOfOriginSetCard.backColor
        layer.borderColor = SizeRatioOfOriginSetCard.borderColor
        layer.borderWidth = isSelected ? SizeRatioOfOriginSetCard.lineWidth : 0
        layer.cornerRadius = cornerRadius
        layer.masksToBounds = true
    }
}

// MARK: - Constants
extension SetCardView {
    private struct SizeRatioOfOriginSetCard {
        static let boundsHeight: CGFloat = 400
        static let boundsWidth: CGFloat = 250
        static let cornerRadiusCoefficient: CGFloat = 0.08
        static let cardColor: UIColor = UIColor.white
        static let borderColor: CGColor = UIColor.red.cgColor
        static let backColor: UIColor = UIColor.systemPink
        static let lineWidth: CGFloat = 2
        static let scale: CGFloat = 1.3
    }

    private struct CenterOffsetForLayoutShapes {
        static let threeShapesOnCard: CGFloat = 110
        static let twoShapesOnCard: CGFloat = 52
    }

    private var scaleLineWidth: CGFloat {
        scale * SizeRatioOfOriginSetCard.lineWidth
    }

    private var scale: CGFloat {
        SizeRatioOfOriginSetCard.scale * bounds.size.height / SizeRatioOfOriginSetCard.boundsHeight
    }

    private var cornerRadius: CGFloat {
        bounds.size.height * SizeRatioOfOriginSetCard.cornerRadiusCoefficient
    }

    private var coordinatesForShapesLayout: [(dx: CGFloat, dy: CGFloat)] {
        switch card.number {
        case .one:
            return [(bounds.midX, bounds.midY)]
        case .two:
            let offset = CenterOffsetForLayoutShapes.twoShapesOnCard * scale / 1.3
            return [(bounds.midX, bounds.midY + offset),
                    (bounds.midX, bounds.midY - offset)]
        case .three:
            let offset = CenterOffsetForLayoutShapes.threeShapesOnCard * scale / 1.3
            return [(bounds.midX, bounds.midY - offset),
                    (bounds.midX, bounds.midY),
                    (bounds.midX, bounds.midY + offset)]
        }
    }
}

// MARK: - CGContext
fileprivate extension CGContext {
    func fillFigure(shading: SetCard.Shading, color: UIColor, lineWidth: CGFloat) {
        switch shading {
        case .solid:
            color.setFill()
            fillPath()
        case .stripe:
            guard let path = path else {
                return
            }
            let outline = UIBezierPath(cgPath: path)
            addStripes()
            color.setStroke()
            setLineWidth(lineWidth / 2)
            strokePath()
            outline.lineWidth = lineWidth * 2
            outline.stroke()
        case .empty:
            color.setStroke()
            setLineWidth(lineWidth)
            strokePath()
        }
    }

    func createFigurePath(figure: SetCard.Shape, scale: CGFloat, translate: (x: CGFloat, y: CGFloat)) {
        // translate and scale the figure path
        saveGState()
        translateBy(x: translate.x, y: translate.y)
        scaleBy(x: scale, y: scale)

        // create figure path
        switch figure {
        case .diamond:
            createDiamondPath()
        case .oval:
            createOvalPath()
        case .squiggle:
            createSquigglePath()
        }

        restoreGState()
    }

    private func addStripes() {
        clip()
        let boundsHeight = 400
        let boundsWidth = 250
        for x in stride(from: 0, through: boundsWidth, by: 3) {
            move(to: CGPoint(x: x, y: 0))
            addLine(to: CGPoint(x: x, y: boundsHeight))
        }
    }

    private func createDiamondPath() {
        // create the diamond path
        let leftCorner = CGPoint(x: -66, y: 2)
        let lowerCorner = CGPoint(x: 0, y: 34)
        let rightCorner = CGPoint(x: 66, y: 2)
        let upperCorner = CGPoint(x: 0, y: -30)

        move(to: leftCorner)
        addLine(to: upperCorner)
        addLine(to: rightCorner)
        addLine(to: lowerCorner)

        closePath()
    }

    private func createSquigglePath() {
        // create the squiggle path

        move(to: CGPoint(x: 57.8, y: -26))

        let pathPoints = [
            (to: CGPoint(x: 8.6, y: 20.8), control1: CGPoint(x: 67.880, y: 0.28),
                    control2: CGPoint(x: 40.64, y: 28.96)),
            (to: CGPoint(x: -34.6, y: 19.6), control1: CGPoint(x: -4.24, y: 17.56),
                    control2: CGPoint(x: -16.36, y: 6.4)),
            (to: CGPoint(x: -61, y: 4), control1: CGPoint(x: -55.48, y: 34.720),
                    control2: CGPoint(x: -60.52, y: 25.96)),
            (to: CGPoint(x: -23.8, y: -29), control1: CGPoint(x: -61.48, y: -17.6),
                    control2: CGPoint(x: -44.08, y: -32.36)),
            (to: CGPoint(x: 39.8, y: -27), control1: CGPoint(x: 4.04, y: -25.76),
                    control2: CGPoint(x: 7.28, y: -6.2)),
            (to: CGPoint(x: 57.8, y: -26), control1: CGPoint(x: 47.36, y: -32),
                    control2: CGPoint(x: 54.08, y: -35.72)),
        ]

        for (to, control1, control2) in pathPoints {
            addCurve(to: to, control1: control1, control2: control2)
        }

        setLineCap(.round)
    }

    private func createOvalPath() {
        // create the oval path
        move(to: CGPoint(x: -32, y: -28))
        addLine(to: CGPoint(x: 33, y: -28))
        addArc(center: CGPoint(x: 33, y: 1), radius: 29, startAngle: -CGFloat.pi / 2,
                endAngle: CGFloat.pi / 2, clockwise: false)
        addLine(to: CGPoint(x: -32, y: 30))
        addArc(center: CGPoint(x: -32, y: 1), radius: 29, startAngle: CGFloat.pi / 2,
                endAngle: CGFloat.pi / 2 * 3, clockwise: false)
    }
}
