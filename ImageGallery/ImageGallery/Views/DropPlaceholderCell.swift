//
//  DropPlaceholderCell.swift
//  ImageGallery
//
//  Created by 6ai on 17/04/2020.
//  Copyright © 2020 6ai. All rights reserved.
//

import UIKit

class DropPlaceholderCell: UICollectionViewCell {
    let loadingActivityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(loadingActivityIndicator)
        loadingActivityIndicator.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor)
        loadingActivityIndicator.startAnimating()
        backgroundColor = .white
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder: ) has not been implemented")
    }
}
