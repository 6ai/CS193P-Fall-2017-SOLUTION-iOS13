//
//  Created by yasuhiko2 on 04/03/2020.
//  Copyright © 2020 yasuhiko2. All rights reserved.
//

import UIKit

class BarInfo: UIStackView {

    let layingOutCardsLabel: UILabel = {
        let label = UILabel()
        label.attributedText = centeredAttributedString("Deal", fontSize: 32)
        label.backgroundColor = .backOfCardColor
        label.layer.masksToBounds = true

        return label
    }()

    let numberOfCollectedSetsLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .backOfCardColor
        label.alpha = 0
        label.attributedText = centeredAttributedString("Stack", fontSize: 32)
        label.layer.masksToBounds = true

        return label
    }()

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        configure()

        [layingOutCardsLabel, numberOfCollectedSetsLabel].forEach({ addArrangedSubview($0) })
    }

    private class func centeredAttributedString(_ string: String, fontSize: CGFloat) -> NSAttributedString {
        var font = UIFont.preferredFont(forTextStyle: .body).withSize(fontSize)
        font = UIFontMetrics(forTextStyle: .body).scaledFont(for: font)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        return NSAttributedString(string: string,
                attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle, .font: font])
    }

    private func configure() {
        axis = .horizontal
        alignment = .fill
        distribution = .fillEqually
        spacing = 4
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        layingOutCardsLabel.layer.cornerRadius = contentViewCornerRadius
        numberOfCollectedSetsLabel.layer.cornerRadius = contentViewCornerRadius
    }
}

extension BarInfo {
    private var contentViewCornerRadius: CGFloat {
        layingOutCardsLabel.bounds.height * SizeRatio.cornerRadiusCoefficient
    }

    private struct SizeRatio {
        static let cornerRadiusCoefficient: CGFloat = 0.08
    }

}
