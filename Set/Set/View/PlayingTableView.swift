//
// Created by iloveass on 23/03/2020.
// Copyright (c) 2020 Annette. All rights reserved.
//

import UIKit

class PlayingTableView: UIView {
    private(set) var tableCardsLayout: [TableCard] = []
    var tableViewGrid = Grid(layout: .aspectRatio(CardLayout.cardRatio))

    var tableCards: [PlayingCard] = [] {
        didSet { recalculate() }
    }
    private func recalculate() {
        clearTableViewFromSubviews()
        tableViewGrid.cellCount = tableCards.count
        tableCardsLayout.removeAll(where: {
            switch $0.stat {
            case .deleted:
                return true
            default:
                return false
            }
        })


        if tableCardsLayout.count > tableCards.count {
            for index in tableCardsLayout.indices {
                let cardOnTable = tableCardsLayout[index].view.card
                if !tableCards.contains(cardOnTable) {
                    tableCardsLayout[index].stat = .deleted
                }
            }
        }

        for index in tableCards.indices {
            let newCard = tableCards[index]
            let newCellFrame = tableViewGrid[index]?.narrowDown(by: CardLayout.spacingBetweenCards) ?? CGRect.zero
            let newCardView = PlayingCardView(frame: newCellFrame, card: newCard)
            if index >= tableCardsLayout.count {
                tableCardsLayout.append(TableCard(view: newCardView, stat: .newCardFromDeck))
                continue
            }
            let cardOnTableView = tableCardsLayout[index].view
            if newCard != cardOnTableView.card {
                cardOnTableView.removeFromSuperview()
                tableCardsLayout[index].stat = .matchedCard(cardOnTableView)
                tableCardsLayout[index].view = newCardView
            } else {
                tableCardsLayout[index].stat = .updateFrame(newCellFrame)
            }
        }
    }

    subscript(index: Int) -> TableCard? {
        return index < tableCardsLayout.count ? tableCardsLayout[index] : nil
    }

    func clearTableViewFromSubviews() {
        subviews.forEach { $0.removeFromSuperview() }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        tableViewGrid.frame = bounds
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        tableViewGrid.frame = frame
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        tableViewGrid.frame = frame
    }
}

extension PlayingTableView {
    private struct CardLayout {
        static let cardRatio: CGFloat = 5 / 8
        static let spacingBetweenCards: CGFloat = 5
    }

    enum PlayingCardStatOnTable {
        case matchedCard(PlayingCardView)
        case updateFrame(CGRect)
        case newCardFromDeck
        case deleted
    }

    struct TableCard {
        var view: PlayingCardView
        var stat: PlayingCardStatOnTable
    }
}

extension CGRect {
    func narrowDown(by: CGFloat) -> CGRect {
        let newSize = CGSize(width: self.width - by, height: self.height - by)
        return CGRect(origin: self.origin, size: newSize)
    }
}
