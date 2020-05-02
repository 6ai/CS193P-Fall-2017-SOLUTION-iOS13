//
//  ImageGalleryCollectionViewCell.swift
//  ImageGallery
//
//  Created by 6ai on 11/04/2020.
//  Copyright © 2020 6ai. All rights reserved.
//

import UIKit

class ImageCell: UICollectionViewCell {

    // MARK: - Properties
    private(set) var width: CGFloat?
    private(set) var height: CGFloat?

    private let activityIndicator = UIActivityIndicatorView()

    var imageURL: URL? { didSet { fetchImage() } }
    private var image: UIImage? {
        get {
            return imageView.image
        }
        set {
            activityIndicator.stopAnimating()
            imageView.image = newValue
            imageView.sizeToFit()
        }
    }

    private var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .white
        return imageView
    }()

    private func fetchImage() {
        activityIndicator.startAnimating()
        DispatchQueue.global(qos: .utility).async {
            guard let url = self.imageURL, let imageData = try? Data(contentsOf: url) else { return }
            DispatchQueue.main.async {
                self.image = UIImage(data: imageData)
            }
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(imageView)
        imageView.addSubview(activityIndicator)
        setupAutolayout()
    }

    private func setupAutolayout() {
        imageView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor)
        activityIndicator.anchor(top: imageView.topAnchor, left: imageView.leftAnchor, bottom: imageView.bottomAnchor, right: imageView.rightAnchor)

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}



