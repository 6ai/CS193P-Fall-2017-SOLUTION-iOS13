//
//  ImageGalleryCollectionViewCell.swift
//  ImageGallery
//
//  Created by ccoleridge on 11/04/2020.
//  Copyright © 2020 ccoleridge. All rights reserved.
//

import UIKit

class ImageGalleryCollectionViewCell: UICollectionViewCell {
    let label = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemRed
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder: ) has not been implemented")
    }
}
