//
//  ViewController.swift
//  Concentration
//
// Created by yasuhiko2 on 03/04/2020.
// Copyright (c) 2020 yasuhiko2. All rights reserved.
//


import UIKit

class ViewController: UIViewController {
    @IBOutlet private weak var scoreLabel: UILabel! {
        didSet {
            setScoreLabel()
        }
    }
    @IBOutlet private var cardButtons: [UIButton]!

    private lazy var amountOfPairsOfCards = {
        (cardButtons.count + 1) / 2
    }()

    private var emojiChoice: [String] = ["👻", "😈", "👾", "🌑", "🍭", "💀", "🧛🏿‍", "🧟‍️", "🧛‍", "👁"]
    private lazy var game = Concentration(
            numberOfCards: amountOfPairsOfCards,
            emojiChoice: emojiChoice
    )

    private func setScoreLabel() {
        scoreLabel.text = "Score: \(game.score)"
    }

    @IBAction private func createNewGame(_ sender: UIButton) {
        for cardButton in cardButtons {
            cardButton.backgroundColor = .orange
            cardButton.setTitle("", for: .normal)
        }
        game = Concentration(
                numberOfCards: (cardButtons.count + 1) / 2,
                emojiChoice: emojiChoice
        )
        setScoreLabel()
    }

    @IBAction private func touchCard(_ sender: UIButton) {
        guard let cardNumber = cardButtons.firstIndex(of: sender) else {
            return
        }
        guard !game.cards[cardNumber].isFaceUp else {
            return
        }

        game.chooseCard(at: cardNumber)
        updateViewFromModel()
    }

    private func updateViewFromModel() {
        for index in cardButtons.indices {
            let cardButton = cardButtons[index]
            let card = game.cards[index]
            let title = card.isFaceUp ? card.emoji : ""
            let background: UIColor = card.isFaceUp ? .white : .orange
            cardButton.setTitle(title, for: .normal)
            cardButton.backgroundColor = background
            setScoreLabel()
        }
    }
}

