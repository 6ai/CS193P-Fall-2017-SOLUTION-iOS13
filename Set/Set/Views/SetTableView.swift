//
// Created by yasuhiko2 on 23/03/2020.
// Copyright (c) 2020 yasuhiko2. All rights reserved.
//

import UIKit

protocol SetTableViewDelegate {
    func clickOnCard(card: SetCard)
}

class SetTableView: UIView {
    private(set) var frameGrid = Grid(layout: .aspectRatio(CardLayout.aspectRatio))
    private(set) var views: [SetCardView] = []

    var delegate: SetTableViewDelegate!
    var cards: [SetCard] = [] {
        didSet {
            recalculate()
        }
    }

    subscript(index: Int) -> SetCardView {
        get {
            assert(index < views.count, "Index out of range")
            return views[index]
        }
        set(newValue) {
            assert(index < views.count, "Index out of range")
            views[index] = newValue
            recalculate()
        }
    }

    func clearTableViewFromSubviews() {
        subviews.forEach {
            $0.removeFromSuperview()
        }
    }

    private func recalculate() {
        clearTableViewFromSubviews()
        frameGrid.frame = bounds
        frameGrid.cellCount = cards.count
        while cards.count < views.count {
            views.removeLast()
        }
        for index in cards.indices {
            let card = cards[index]
            let cellFrame = frameGrid[index]!.narrowDown(by: CardLayout.spacingBetweenCards)
            let lastFrame = (index < views.count) ? views[index].frame : cellFrame
            let cardView = SetCardView(frame: lastFrame, card: card)
            let tap = UITapGestureRecognizer(target: self, action: #selector(clickOnCardView))
            cardView.addGestureRecognizer(tap)
            (index < views.count) ? (views[index] = cardView) : views.append(cardView)
            UIViewPropertyAnimator.runningPropertyAnimator(
                    withDuration: 1,
                    delay: 0,
                    animations: { cardView.frame = cellFrame }
            )
            addSubview(cardView)
        }
    }

    @objc private func clickOnCardView(_ recognizer: UITapGestureRecognizer) {
        guard let cardView = recognizer.view as? SetCardView else {
            return
        }
        delegate.clickOnCard(card: cardView.card)
    }
}

extension SetTableView {
    private struct CardLayout {
        static let aspectRatio: CGFloat = 5 / 8
        static let spacingBetweenCards: CGFloat = 5
    }
}

extension CGRect {
    func narrowDown(by: CGFloat) -> CGRect {
        let newSize = CGSize(width: self.width - by, height: self.height - by)
        return CGRect(origin: self.origin, size: newSize)
    }
}
