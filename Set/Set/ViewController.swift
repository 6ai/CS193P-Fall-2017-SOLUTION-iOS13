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
    @IBOutlet private var cardButtons: [GameCardButton]!

    private var game = Game()

    @IBAction private func startNewGame(_ sender: UIButton) {
        game = Game()
        updateViewFromModel()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        updateViewFromModel()
    }

    private func getAttributedString(for card: Card?) -> NSAttributedString {
        guard let card = card else {
            return NSMutableAttributedString()
        }

        let color = card.color.getUIColor()
        let alpha = card.shading.getAlpha()
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: color.withAlphaComponent(alpha)
        ]

        let string: String
        let shape = card.shape.getShape()
        switch card.number {
        case .one:
            string = "\n\(shape)\n"
        case .two:
            string = "\(shape)\n\(shape)"
        case .three:
            string = "\(shape)\n\(shape)\n\(shape)"
        }

        return NSAttributedString(string: string, attributes: attributes)
    }

    @IBAction private func touchCard(_ button: GameCardButton) {
        guard let index = cardButtons.firstIndex(of: button) else {
            return
        }
        if game.chosenCards.contains(index) {
            game.disapproveCard(at: index)
        } else {
            game.chooseCard(at: index)
        }
        updateViewFromModel()
    }


    private func updateViewFromModel() {
        scoreLabel.text = "Score: \(game.score)"
        for index in cardButtons.indices {
            let btn = cardButtons[index]
            let card = game.cardsOnTable[index]
            btn.setAttributedTitle(getAttributedString(for: card), for: .normal)

            if game.chosenCards.contains(index) {
                btn.layer.borderWidth = 3.0
                btn.layer.borderColor = UIColor.blue.cgColor
            } else {
                btn.layer.borderWidth = 0.0
            }
        }
    }
}

