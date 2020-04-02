//
//  Created by yasuhiko2 on 04/03/2020.
//  Copyright © 2020 yasuhiko2. All rights reserved.
//

import UIKit

class SetViewController: UIViewController {
    private var game = SetGame()

    private let barInfo: BarInfo = {
        let stackView = BarInfo()
        stackView.translatesAutoresizingMaskIntoConstraints = false

        return stackView
    }()

    private let setTableView: SetTableView = {
        let tableView = SetTableView()
        tableView.backgroundColor = .clear
        tableView.translatesAutoresizingMaskIntoConstraints = false

        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // todo move
        view.backgroundColor = #colorLiteral(red: 0.478271801, green: 0.4424946756, blue: 0.6212127221, alpha: 0.6511932791)
        let tap = UITapGestureRecognizer(target: self, action: #selector(layingOutThreeCardsOnTable))
        barInfo.addGestureRecognizer(tap)

        setTableView.delegate = self

        view.addSubview(barInfo)
        view.addSubview(setTableView)

        setupLayout()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateViewFromModel()
    }

    @objc private func layingOutThreeCardsOnTable() {
        guard game.cardOnTable.count <= 21 else {
            return
        }
        game.addCardsOnTable(countOfCards: 3)
        updateViewFromModel()
    }

    private func updateViewFromModel() {
        barInfo.dealButton.alpha = game.deck.isEmpty() ? 0 : 1
        let matchedCards = setTableView.views.filter {
            game.lastMatchedCard.contains($0.card)
        }
        setTableView.cards = game.cardOnTable
        setTableView.views.forEach {
            $0.isSelected = game.cardsOnHands.contains($0.card)
        }
        let needLayingOutCards = setTableView.views.filter {
            game.lastAddedCard.contains($0.card)
        }

        layingOutCardAnimation(needLayingOutCards)
        cardsAfterMatchedAnimation(matchedCards: matchedCards)
    }



    // Mark: Dynamic Animator
    private lazy var animator = UIDynamicAnimator(referenceView: setTableView)
    private lazy var cardBehavior = SetCardBehavior(in: animator)

    private func layingOutCardAnimation(_ cardViews: [SetCardView]) {
        let deckOriginCenter = barInfo.convert(barInfo.dealButton.frame.origin, to: setTableView)
        let deckOriginFrame = CGRect(origin: deckOriginCenter, size: barInfo.dealButton.frame.size)

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

    private func cardsAfterMatchedAnimation(matchedCards: [SetCardView]) {
        let setCountViewCenter = barInfo.convert(barInfo.setCountButton.frame.origin, to: setTableView)
        let setCountViewFrame = CGRect(origin: setCountViewCenter, size: barInfo.dealButton.frame.size)

        for matchCard in matchedCards {
            matchCard.isSelected = false
            let horizontalRotationCardAnimation = {
                matchCard.transform = CGAffineTransform.identity.rotated(by: CGFloat.pi / 2)
            }

            let flipOnStackOfCardsAnimation: (UIViewAnimatingPosition) -> () = { _ in
                self.barInfo.setCountButton.alpha = 0
                UIView.transition(
                        with: matchCard,
                        duration: 0.8,
                        options: [.transitionFlipFromLeft],
                        animations: { matchCard.isFaceUp = false },
                        completion: { _ in
                            self.barInfo.setCountButton.alpha = 1
                            matchCard.alpha = 0
                            self.barInfo.setCountButton.text = "\(self.game.matchedCount) Sets"
                        }
                )
            }

            let moveCardsToStackOfCardsAnimation: (Bool) -> () = { _ in
                UIViewPropertyAnimator.runningPropertyAnimator(
                        withDuration: 0.5,
                        delay: 0.1,
                        options: [.curveEaseIn],
                        animations: { matchCard.frame = setCountViewFrame },
                        completion: flipOnStackOfCardsAnimation)
            }

            setTableView.addSubview(matchCard)
            cardBehavior.addItem(matchCard)

            Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { _ in
                self.cardBehavior.removeItem(matchCard)
                UIView.transition(
                        with: matchCard,
                        duration: 0.2,
                        animations: { horizontalRotationCardAnimation() },
                        completion: moveCardsToStackOfCardsAnimation)
            })
        }
    }

    // Mark: Autolayout
    private func setupLayout() {
        let safeGuide = view.safeAreaLayoutGuide

        let constraints = [
            barInfo.leadingAnchor.constraint(equalTo: safeGuide.leadingAnchor),
            barInfo.trailingAnchor.constraint(equalTo: safeGuide.trailingAnchor),
            barInfo.bottomAnchor.constraint(equalTo: safeGuide.bottomAnchor, constant: -4),
            barInfo.topAnchor.constraint(equalTo: setTableView.bottomAnchor, constant: 4),
            barInfo.heightAnchor.constraint(equalToConstant: 80),

            setTableView.trailingAnchor.constraint(equalTo: safeGuide.trailingAnchor),
            setTableView.leadingAnchor.constraint(equalTo: safeGuide.leadingAnchor),
            setTableView.topAnchor.constraint(equalTo: safeGuide.topAnchor, constant: 4)
        ]

        NSLayoutConstraint.activate(constraints)
    }
}

// Mark: - SetTableViewDelegate
extension SetViewController: SetTableViewDelegate {
    func clickOnCard(card: SetCard) {
        game.cardsOnHands.contains(card) ? game.discard(card: card) : game.takeCardFromTable(card: card)
        updateViewFromModel()
    }
}

