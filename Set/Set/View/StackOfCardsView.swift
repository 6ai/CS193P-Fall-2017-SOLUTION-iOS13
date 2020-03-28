//
// Created by iloveass on 20/03/2020.
// Copyright (c) 2020 Annette. All rights reserved.
//

import UIKit

@IBDesignable
class StackOfCardsView: UIButton {
    var text = "" {
        didSet {
            setAttributedTitle(centeredAttributedString(text, fontSize: 32), for: .normal)
        }
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    private func configure() {
        backgroundColor = .systemPink
//        let label = createCenteredLabel()
//        addSubview(label)
        layer.cornerRadius = cornerRadius
        layer.masksToBounds = true
//        print(label.frame)
    }

    private func configureCenteredLabel(_ label: UILabel) {

    }

    private func createCenteredLabel() -> UILabel {
        let label = UILabel()
        label.frame = frame
        label.attributedText = centeredAttributedString("Deal", fontSize: 34)
        return label
    }

    private func centeredAttributedString(_ string: String, fontSize: CGFloat) -> NSAttributedString {
        var font = UIFont.preferredFont(forTextStyle: .body).withSize(fontSize)
        font = UIFontMetrics(forTextStyle: .body).scaledFont(for: font)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .left
        return NSAttributedString(string: string, attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle, .font: font])
    }

    private var cornerRadius: CGFloat {
        return bounds.size.height * 0.08
    }
}
