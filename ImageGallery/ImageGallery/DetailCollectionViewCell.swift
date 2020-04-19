//
//  ImageGalleryCollectionViewCell.swift
//  ImageGallery
//
//  Created by ccoleridge on 11/04/2020.
//  Copyright © 2020 ccoleridge. All rights reserved.
//

import UIKit

class DetailCollectionViewCell: UICollectionViewCell {

    // MARK: - Properties
    private(set) var width: CGFloat?
    private(set) var height: CGFloat?

    private var image: UIImage?

    var imageURL: URL? {
        didSet {
            image = nil
            fetchImage()
        }
    }

    private func fetchImage() {
        if let url = imageURL {
            let urlContents = try? Data(contentsOf: url)
            if let imageData = urlContents {
                image = UIImage(data: imageData)
                print("log: image.size: \(image?.size)")
                width = image?.size.width
                height = image?.size.height
            }
        }
    }

    // MARK: - Lifecycle
    override func layoutSubviews() {
        super.layoutSubviews()
        subviews.forEach({ $0.removeFromSuperview() })
        if image != nil {
            let imageView = UIImageView(image: image)
            addSubview(imageView)
            imageView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor)
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
