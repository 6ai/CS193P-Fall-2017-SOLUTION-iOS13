//
//  DropPlaceholderCell.swift
//  ImageGallery
//
//  Created by iloveass on 17/04/2020.
//  Copyright © 2020 yasuhiko2. All rights reserved.
//

import UIKit

class DropPlaceholderCell: UICollectionViewCell {
    var loadingActivityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        return indicator
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(loadingActivityIndicator)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder: ) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        loadingActivityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        loadingActivityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }

}
