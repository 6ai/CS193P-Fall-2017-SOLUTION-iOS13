//
//  ViewController.swift
//  Set
//
//  Created by nattle on 04/03/2020.
//  Copyright © 2020 Annette. All rights reserved.
//

import UIKit


class ViewController: UIViewController {
    @IBOutlet private weak var scoreLabel: UILabel!
    private lazy var tableViewGrid = Grid(layout: .aspectRatio(Constants.cardRatio), frame: tableView.bounds)
    private var game = Game()
    @IBOutlet weak var tableView: UIView! {
        didSet {
            let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(addMoreCards))
            swipeDown.direction = [.down]
            tableView.addGestureRecognizer(swipeDown)

            let pinch = UIPinchGestureRecognizer(target: self, action: #selector(reshuffleCards))
            tableView.addGestureRecognizer(pinch)
        }
    }

    @objc private func reshuffleCards(_ recognizer: UIPinchGestureRecognizer) {
        switch recognizer.state {
        case .ended:
            game.reshuffleCardsOnTable()
            updateViewFromModel()
        default:
            break
        }
    }

    @objc private func addMoreCards(_ recognizer: UISwipeGestureRecognizer) {
        switch recognizer.state {
        case .ended:
            game.addCardsOnTable()
            clearTableViewFromSubviews()
            updateViewFromModel()
        default:
            break
        }

    }

    @IBAction private func startNewGame(_ sender: UIButton) {
        game = Game()
        updateViewFromModel()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableViewGrid = Grid(layout: .aspectRatio(Constants.cardRatio), frame: tableView.bounds)
        clearTableViewFromSubviews()
        updateViewFromModel()
    }

    private func clearTableViewFromSubviews() {
        tableView.subviews.forEach { $0.removeFromSuperview() }
    }

    private func updateViewFromModel() {
        scoreLabel.text = "Score: \(game.score)"
        tableViewGrid.cellCount = game.cardsOnTable.count

        for index in game.cardsOnTable.indices {
            let card = game.cardsOnTable[index]
            let cellFrame = tableViewGrid[index] ?? CGRect.zero
            let cardView = CardView(frame: cellFrame.narrowDown(by: Constants.cardsOffset), card: card)
            cardView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(touchCard)))
            tableView.addSubview(cardView)

            if game.chosenCards.contains(card) {
                cardView.addBorder()
            } else {
                cardView.removeBorder()
            }
        }
    }

    @objc private func touchCard(_ recognizer: UITapGestureRecognizer) {
        guard let cardView = recognizer.view as? CardView else { return }
        let card = cardView.card
        if game.chosenCards.contains(card) {
            game.disapproveCard(card: card)
        } else {
            game.chooseCard(card: card)
        }
        updateViewFromModel()
    }
}

extension ViewController {
    private struct Constants {
        static let cardRatio: CGFloat = 5 / 8
        static let cardsOffset: CGFloat = 5
    }
}

extension CGRect {
    func narrowDown(by: CGFloat) -> CGRect {
        let newSize = CGSize(width: self.width - by, height: self.height - by)
        return CGRect(origin: self.origin, size: newSize)
    }
}


