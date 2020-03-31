//
//  Created by yasuhiko2 on 04/03/2020.
//  Copyright © 2020 yasuhiko2. All rights reserved.
//

import UIKit

class ViewController: UIViewController, PlayingTableViewDelegate {
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
    @IBOutlet weak var setCountButton: StackOfCardsView! {
        didSet {
            setCountButton.alpha = 0
        }
    }
    @IBOutlet weak var stackView: UIView!

    private var game = SetGame()
    @IBOutlet weak var tableView: PlayingTableView! { didSet { tableView.delegate = self } }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateViewFromModel()
    }

    private func updateViewFromModel() {
        playingDeckView.alpha = game.deck.isEmpty() ? 0 : 1
        let matchedCards = tableView.views.filter { game.lastMatchedCards.contains($0.card) }
        tableView.cards = game.cardsOnTable
        tableView.views.forEach { $0.isSelected = game.takenCards.contains($0.card) }
        let needLayingOutCards = tableView.views.filter { game.lastAddedCard.contains($0.card) }
        layingOutCardAnimation(needLayingOutCards)
        cardsAfterMatchedAnimation(matchedCards: matchedCards)
    }

    func clickOnCard(card: PlayingCard) {
        game.takenCards.contains(card) ? game.discard(card: card) : game.takeCardFromTable(card: card)
        updateViewFromModel()
    }

    // Mark: Dynamic Animator
    private lazy var animator = UIDynamicAnimator(referenceView: tableView)
    private lazy var cardBehavior = PlayingCardBehavior(in: animator)

    private func layingOutCardAnimation(_ cardViews: [PlayingCardView]) {
        print(#function)
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

    private func cardsAfterMatchedAnimation(matchedCards: [PlayingCardView]) {
        print(#function)

        let setCountViewCenter = stackView.convert(setCountButton.frame.origin, to: tableView)
        let setCountViewFrame = CGRect(origin: setCountViewCenter, size: playingDeckView.frame.size)

        for matchCard in matchedCards {
            matchCard.isSelected = false
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

            let moveCardsToStackOfCardsAnimation: (Bool) -> ()  = { _ in
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
                        completion: moveCardsToStackOfCardsAnimation )
            })
        }
    }
}


