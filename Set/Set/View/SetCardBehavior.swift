//
//  Created by yasuhiko2 on 04/03/2020.
//  Copyright © 2020 yasuhiko2. All rights reserved.
//


import UIKit

class SetCardBehavior: UIDynamicBehavior {
    private lazy var collisionBehavior: UICollisionBehavior = {
        let behavior = UICollisionBehavior()
        behavior.translatesReferenceBoundsIntoBoundary = true
        return behavior
    }()

    private lazy var itemBehavior: UIDynamicItemBehavior = {
        let behavior = UIDynamicItemBehavior()
        behavior.allowsRotation = true
        behavior.elasticity = 1.0
        behavior.resistance = 0
        return behavior
    }()

    private func push(_ item: UIDynamicItem) {
        let behavior = UIPushBehavior(items: [item], mode: .instantaneous)
        behavior.angle = CGFloat.pi * 3 / 4 - (2 * CGFloat.pi).arc4random
        behavior.magnitude = CGFloat(5) + CGFloat(5).arc4random
        behavior.action = { [unowned behavior, weak self] in
            self?.removeChildBehavior(behavior)
        }
        addChildBehavior(behavior)
    }

    func addItem(_ item: UIDynamicItem) {
        collisionBehavior.addItem(item)
        itemBehavior.addItem(item)
        push(item)
    }

    func removeItem(_ item: UIDynamicItem) {
        collisionBehavior.removeItem(item)
        itemBehavior.removeItem(item)
    }

    override init() {
        super.init()
        addChildBehavior(collisionBehavior)
        addChildBehavior(itemBehavior)
    }

    convenience init(in animator: UIDynamicAnimator) {
        self.init()
        animator.addBehavior(self)
    }
}

extension CGFloat {
    var arc4random: CGFloat {
        return self * (CGFloat(arc4random_uniform(UInt32.max)) / CGFloat(UInt32.max))
    }
}