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

        configure()

        setTableView.delegate = self

        view.addSubview(barInfo)
        view.addSubview(setTableView)

        setupLayout()
    }

    private func configure() {
        view.backgroundColor = .gameTableColor
        let tap = UITapGestureRecognizer(
                target: self, action: #selector(layingOutThreeCardsOnTable))
        barInfo.addGestureRecognizer(tap)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateViewFromModel()
    }

    @objc private func layingOutThreeCardsOnTable() {
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

    // MARK: Dynamic Animator
    private lazy var animator = UIDynamicAnimator(referenceView: setTableView)
    private lazy var cardBehavior = SetCardBehavior(in: animator)
}

// MARK: - SetTableViewDelegate
extension SetViewController: SetTableViewDelegate {
    func clickOnCard(card: SetCard) {
        game.cardsOnHands.contains(card) ? game.discard(card: card) :
                game.takeCardFromTable(card: card)
        updateViewFromModel()
    }
}

extension SetViewController {
    private var setCountViewCenter: CGPoint {
        barInfo.convert(barInfo.setsCountLabel.frame.origin, to: setTableView)
    }

    private var setCountViewFrame: CGRect {
        CGRect(origin: setCountViewCenter, size: barInfo.dealButton.frame.size)
    }

    private var deckOriginCenter: CGPoint {
        barInfo.convert(barInfo.dealButton.frame.origin, to: setTableView)
    }

    private var deckOriginFrame: CGRect {
        CGRect(origin: deckOriginCenter, size: barInfo.dealButton.frame.size)
    }
}

// MARK: - Animation
extension SetViewController {
    private func layingOutCardAnimation(_ cardViews: [SetCardView]) {
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
        for matchCard in matchedCards {
            matchCard.isSelected = false
            let horizontalRotationCardAnimation = {
                matchCard.transform = CGAffineTransform.identity.rotated(by: CGFloat.pi / 2)
            }

            let flipOnStackOfCardsAnimation: (UIViewAnimatingPosition) -> () = { _ in
                self.barInfo.setsCountLabel.alpha = 0
                UIView.transition(
                        with: matchCard,
                        duration: 0.8,
                        options: [.transitionFlipFromLeft],
                        animations: { matchCard.isFaceUp = false },
                        completion: { _ in
                            self.barInfo.setsCountLabel.alpha = 1
                            self.barInfo.setsCountLabel.text = "\(self.game.matchedCount) Sets"
                            matchCard.alpha = 0
                        }
                )
            }

            let moveCardsToStackOfCardsAnimation: (Bool) -> () = { _ in
                UIViewPropertyAnimator.runningPropertyAnimator(
                        withDuration: 0.5,
                        delay: 0.1,
                        options: [.curveEaseIn],
                        animations: { matchCard.frame = self.setCountViewFrame },
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
}

// MARK: - Autolayout
extension SetViewController {
    private func setupLayout() {
        let safeArea = view.safeAreaLayoutGuide

        let constraints = [
            barInfo.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            barInfo.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            barInfo.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -4),
            barInfo.topAnchor.constraint(equalTo: setTableView.bottomAnchor, constant: 4),
            barInfo.heightAnchor.constraint(equalToConstant: 80),

            setTableView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            setTableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            setTableView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 4)
        ]

        NSLayoutConstraint.activate(constraints)
    }
}

