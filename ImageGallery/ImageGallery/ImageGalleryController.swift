//
//  ViewController.swift
//  ImageGallery
//
//  Created by ccoleridge on 10/04/2020.
//  Copyright © 2020 ccoleridge. All rights reserved.
//

import UIKit


class ImageGalleryController: UICollectionViewController {

    fileprivate let cellIdentifier = "imageGalleryCollectionViewCell"
    let images: [UIImage] = [
        #imageLiteral(resourceName: "Image05"),
        #imageLiteral(resourceName: "Image01"),
        #imageLiteral(resourceName: "Image03"),
        #imageLiteral(resourceName: "Image02"),
        #imageLiteral(resourceName: "Image04")
    ]

    override func viewDidLoad() {
        super.viewDidLoad()

        configureCollectionView()
    }

    private func configureCollectionView() {
        collectionView.register(ImageGalleryCollectionViewCell.self, forCellWithReuseIdentifier: cellIdentifier)
        collectionView.backgroundColor = .systemPurple
    }
}

// MARK: - UICollectionViewDataSource & UICollectionViewDelegate

extension ImageGalleryController {
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath)
                    -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: cellIdentifier, for: indexPath as IndexPath) as! ImageGalleryCollectionViewCell
        cell.image = images[indexPath.row]
        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension ImageGalleryController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return images[indexPath.row].size
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
}


extension UIView {

    func anchor(top: NSLayoutYAxisAnchor? = nil, left: NSLayoutXAxisAnchor? = nil, bottom: NSLayoutYAxisAnchor? = nil,
                right: NSLayoutXAxisAnchor? = nil, paddingTop: CGFloat? = 0, paddingLeft: CGFloat? = 0,
                paddingBottom: CGFloat? = 0, paddingRight: CGFloat? = 0, width: CGFloat? = nil,
                height: CGFloat? = nil) {

        translatesAutoresizingMaskIntoConstraints = false

        if let top = top {
            topAnchor.constraint(equalTo: top, constant: paddingTop!).isActive = true
        }

        if let left = left {
            leftAnchor.constraint(equalTo: left, constant: paddingLeft!).isActive = true
        }

        if let bottom = bottom {
            if let paddingBottom = paddingBottom {
                bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom).isActive = true
            }
        }

        if let right = right {
            if let paddingRight = paddingRight {
                rightAnchor.constraint(equalTo: right, constant: -paddingRight).isActive = true
            }
        }

        if let width = width {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }

        if let height = height {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }
}



