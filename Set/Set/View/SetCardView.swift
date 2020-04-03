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
        layer.cornerRadius = bounds.size.height * SizeRatioOfOriginSetCard.cornerRadius
        layer.borderColor = /*isSelected ? */SizeRatioOfOriginSetCard.borderColor /*: .none*/
        layer.masksToBounds = true
    }
}

private extension SetCardView {

    struct SizeRatioOfOriginSetCard {
        static let boundsHeight: CGFloat = 400
        static let boundsWidth: CGFloat = 250
        static let cornerRadius: CGFloat = 0.08
        static let cardColor: UIColor = UIColor.white
        static let borderColor: CGColor = UIColor.red.cgColor
        static let backColor: UIColor = UIColor.systemPink
        static let lineWidth: CGFloat = 2
        static let scale: CGFloat = 1.3
    }

    struct CenterOffsetForLayoutShapes {
        static let threeShapesOnCard: CGFloat = 110
        static let twoShapesOnCard: CGFloat = 52
    }

    var scaleLineWidth: CGFloat {
        return scale * SizeRatioOfOriginSetCard.lineWidth
    }

    var scale: CGFloat {
        return SizeRatioOfOriginSetCard.scale * bounds.size.height / SizeRatioOfOriginSetCard.boundsHeight
    }

    var cornerRadius: CGFloat {
        return bounds.size.height * SizeRatioOfOriginSetCard.cornerRadius
    }

    var coordinatesForShapesLayout: [(dx: CGFloat, dy: CGFloat)] {
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
extension CGContext {

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
        move(to: CGPoint(x: (104.0 * 1.2 - 67), y: (15.0 * 1.2 - 44)))
        addCurve(to: CGPoint(x: (63.00 * 1.2 - 67), y: (54.0 * 1.2 - 44)), control1: CGPoint(x: (112.4 * 1.2 - 67), y: (36.9 * 1.2 - 44)), control2: CGPoint(x: (89.70 * 1.2 - 67), y: (60.8 * 1.2 - 44)))
        addCurve(to: CGPoint(x: (27.00 * 1.2 - 67), y: (53.0 * 1.2 - 44)), control1: CGPoint(x: (52.30 * 1.2 - 67), y: (51.3 * 1.2 - 44)), control2: CGPoint(x: (42.20 * 1.2 - 67), y: (42.0 * 1.2 - 44)))
        addCurve(to: CGPoint(x: (5.000 * 1.2 - 67), y: (40.0 * 1.2 - 44)), control1: CGPoint(x: (9.600 * 1.2 - 67), y: (65.6 * 1.2 - 44)), control2: CGPoint(x: (5.400 * 1.2 - 67), y: (58.3 * 1.2 - 44)))
        addCurve(to: CGPoint(x: (36.00 * 1.2 - 67), y: (12.0 * 1.2 - 44)), control1: CGPoint(x: (4.600 * 1.2 - 67), y: (22.0 * 1.2 - 44)), control2: CGPoint(x: (19.10 * 1.2 - 67), y: (9.70 * 1.2 - 44)))
        addCurve(to: CGPoint(x: (89.00 * 1.2 - 67), y: (14.0 * 1.2 - 44)), control1: CGPoint(x: (59.20 * 1.2 - 67), y: (15.2 * 1.2 - 44)), control2: CGPoint(x: (61.90 * 1.2 - 67), y: (31.5 * 1.2 - 44)))
        addCurve(to: CGPoint(x: (104.0 * 1.2 - 67), y: (15.0 * 1.2 - 44)), control1: CGPoint(x: (95.30 * 1.2 - 67), y: (10.0 * 1.2 - 44)), control2: CGPoint(x: (100.9 * 1.2 - 67), y: (6.90 * 1.2 - 44)))

        setLineCap(.round)
    }

    private func createOvalPath() {
        // create the oval path
        move(to: CGPoint(x: -32, y: -28))
        addLine(to: CGPoint(x: 33, y: -28))
        addArc(center: CGPoint(x: 33, y: 1), radius: 29, startAngle: -CGFloat.pi / 2, endAngle: CGFloat.pi / 2, clockwise: false)
        addLine(to: CGPoint(x: -32, y: 30))
        addArc(center: CGPoint(x: -32, y: 1), radius: 29, startAngle: CGFloat.pi / 2, endAngle: CGFloat.pi / 2 * 3, clockwise: false)
    }
}
