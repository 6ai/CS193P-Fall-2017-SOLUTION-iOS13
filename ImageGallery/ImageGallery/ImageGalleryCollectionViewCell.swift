//
//  ImageGalleryCollectionViewCell.swift
//  ImageGallery
//
//  Created by ccoleridge on 11/04/2020.
//  Copyright © 2020 ccoleridge. All rights reserved.
//

import UIKit

class ImageGalleryCollectionViewCell: UICollectionViewCell {

    // MARK: - Properties

    var image: UIImage? {
        didSet {
            guard let image = image else {
                return
            }
            cellImageView.image = image
        }
    }

    let cellImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = #imageLiteral(resourceName: "Image01")
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()

    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(cellImageView)
        cellImageView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
