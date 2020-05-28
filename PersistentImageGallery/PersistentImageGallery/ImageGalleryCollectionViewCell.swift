//
//  ImageGalleryCollectionViewCell.swift
//  ImageGallery
//
//  Created by aqune on 11/04/2020.
//  Copyright © 2020 aqune. All rights reserved.
//

import UIKit

protocol CellIdentifiable {
    static var identifier: String { get }
}

extension UICollectionViewCell: CellIdentifiable {
    static var identifier: String {
        get { String(describing: Self.self) }
    }
}

class ImageGalleryCollectionViewCell: UICollectionViewCell {

    // MARK: - Properties
    private let activityIndicator = UIActivityIndicatorView()

    var imageURL: URL? { didSet { fetchImage() } }
    var image: UIImage? {
        get {
            imageView.image
        }
        set {
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
            self.activityIndicator.stopAnimating()
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
        activityIndicator.anchor(top: imageView.topAnchor, left: imageView.leftAnchor,
                bottom: imageView.bottomAnchor, right: imageView.rightAnchor)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}



