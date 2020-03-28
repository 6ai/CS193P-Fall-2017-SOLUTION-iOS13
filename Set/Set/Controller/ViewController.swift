//
//  ViewController.swift
//  Set
//
//  Created by nattle on 04/03/2020.
//  Copyright © 2020 Annette. All rights reserved.
//

import UIKit


class ViewController: UIViewController {
    // todo Create barInfo
    @IBOutlet weak var playingDeckView: StackOfCardsView! {
        didSet {
            playingDeckView.text = "Deal"
            playingDeckView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(addMoreCards)))
        }
    }
    @objc private func addMoreCards() {
        game.addCardsOnTable(countOfCards: 3)
        updateViewFromModel()
    }
    @IBOutlet weak var setCountButton: StackOfCardsView!
    @IBOutlet weak var stackView: UIView!

    private var game = SetGame()
    @IBOutlet weak var tableView: PlayingTableView!

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateViewFromModel()
    }

    private func updateViewFromModel() {
        tableView.tableCards = game.cardsOnTable
        var matchedCards: [PlayingCardView] = []
        var needLayingOutCards: [PlayingCardView] = []

        for index in tableView.tableCardsLayout.indices {
            var cardOnTable = tableView.tableCardsLayout[index]
            switch cardOnTable.stat {
            case .matchedCard(let matchedCardView):
                matchedCardView.isSelected = false
                matchedCards.append(matchedCardView)
                needLayingOutCards.append(cardOnTable.view)
            case .updateFrame(let newFrame):
                UIViewPropertyAnimator.runningPropertyAnimator(
                        withDuration: 1, delay: 0, animations: { cardOnTable.view.frame = newFrame })
            case .newCardFromDeck:
                needLayingOutCards.append(cardOnTable.view)
            case .deleted:
                matchedCards.append(cardOnTable.view)
            }
            cardOnTable.view.isSelected = game.takenCards.contains(cardOnTable.view.card)
            tableView.addSubview(cardOnTable.view)
            cardOnTable.view.addGestureRecognizer(UITapGestureRecognizer(
                    target: self, action: #selector(clickOnCardView)))
        }
        layingOutCardAnimation(needLayingOutCards)

        if matchedCards.count == 3 {
            cardsAfterMatchedAnimation(matchedCards: matchedCards)
        }

    }


    @objc private func clickOnCardView(_ recognizer: UITapGestureRecognizer) {
        guard let cardView = recognizer.view as? PlayingCardView else { return }
        let card = cardView.card
        if game.takenCards.contains(card) {
            game.discardHandCard(card: card)
        } else {
            game.takeCardFromTable(card: card)
        }
        updateViewFromModel()
    }


    // Mark: Dynamic Animator
    lazy var animator = UIDynamicAnimator(referenceView: tableView)
    lazy var cardBehavior = PlayingCardBehavior(in: animator)

    func layingOutCardAnimation(_ cardViews: [PlayingCardView]) {
        let deckOriginCenter = stackView.convert(playingDeckView.frame.origin, to: tableView)
        let deckOriginFrame = CGRect(origin: deckOriginCenter, size: playingDeckView.frame.size)

        for index in cardViews.indices {
            let cardView = cardViews[index]
            let cardMoveTo = cardView.frame
            cardView.frame = deckOriginFrame
            cardView.isFaceUp = false

            let flipCardOnDeckAnimation: () -> () = {
                UIView.transition(
                        with: cardView,
                        duration: 0.5,
                        options: [.transitionFlipFromLeft],
                        animations: { cardView.isFaceUp = true }
                )
            }
            UIViewPropertyAnimator.runningPropertyAnimator(
                    withDuration: 0.6,
                    delay: TimeInterval(index) * 0.3,
                    animations: { cardView.frame = cardMoveTo },
                    completion: { _ in flipCardOnDeckAnimation() }
            )
        }
    }

    func cardsAfterMatchedAnimation(matchedCards: [PlayingCardView]) {
        assert(matchedCards.count == 3, "flyawayAnimation: matchedCards must be contains 3 cards not \(matchedCards.count)")

        let setCountViewCenter = stackView.convert(setCountButton.frame.origin, to: tableView)
        let setCountViewFrame = CGRect(origin: setCountViewCenter, size: playingDeckView.frame.size)

        for matchCard in matchedCards {
            let horizontalRotationCardAnimation = {
                matchCard.transform = CGAffineTransform.identity.rotated(by: CGFloat.pi / 2)
            }

            let flipOnStackOfCardsAnimation: (UIViewAnimatingPosition) -> () = { _ in
                self.setCountButton.alpha = 0
                UIView.transition(
                        with: matchCard,
                        duration: 0.8,
                        options: [.transitionFlipFromLeft],
                        animations: { matchCard.isFaceUp = false },
                        completion: { _ in self.setCountButton.alpha = 1
                            self.setCountButton.text = "\(self.game.matchedCount) Sets"
                        }
                )
            }

            let moveCardsOnStackOfCardsAnimation: (Bool) -> ()  = { _ in
                UIViewPropertyAnimator.runningPropertyAnimator(
                        withDuration: 0.5,
                        delay: 0.1,
                        options: [.curveEaseIn],
                        animations: { matchCard.frame = setCountViewFrame },
                        completion: flipOnStackOfCardsAnimation)
            }

            tableView.addSubview(matchCard)
            cardBehavior.addItem(matchCard)
            Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { _ in
                self.cardBehavior.removeItem(matchCard)
                UIView.transition(
                        with: matchCard,
                        duration: 0.2,
                        animations: { horizontalRotationCardAnimation() },
                        completion: moveCardsOnStackOfCardsAnimation )
            })
        }
    }
}


