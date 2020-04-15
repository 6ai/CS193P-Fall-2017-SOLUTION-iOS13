//
//  ViewController.swift
//  ImageGallery
//
//  Created by ccoleridge on 10/04/2020.
//  Copyright © 2020 ccoleridge. All rights reserved.
//

import UIKit


class ImageGalleryController: UICollectionViewController, UIDropInteractionDelegate {

    fileprivate let cellIdentifier = "imageGalleryCollectionViewCell"
    var imageFetcher: ImageFetcher!

    var images: [UIImage] = [
        #imageLiteral(resourceName: "Image05"),
        #imageLiteral(resourceName: "Image01"),
        #imageLiteral(resourceName: "Image03"),
        #imageLiteral(resourceName: "Image02"),
        #imageLiteral(resourceName: "Image04")
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addInteraction(UIDropInteraction(delegate: self))
        configureCollectionView()
    }


    private func configureCollectionView() {
        collectionView.register(ImageGalleryCollectionViewCell.self, forCellWithReuseIdentifier: cellIdentifier)
        collectionView.backgroundColor = .systemPurple
    }
}

// MARK: - Drop items behavior

extension ImageGalleryController {

    func dropInteraction(_ interaction: UIDropInteraction, canHandle session: UIDropSession) -> Bool {
        return session.canLoadObjects(ofClass: NSURL.self) && session.canLoadObjects(ofClass: UIImage.self)
    }

    func dropInteraction(_ interaction: UIDropInteraction, sessionDidUpdate session: UIDropSession) -> UIDropProposal {
        return UIDropProposal(operation: .copy)
    }

    func dropInteraction(_ interaction: UIDropInteraction, performDrop session: UIDropSession) {
        imageFetcher = ImageFetcher() { (url, image) in
            DispatchQueue.main.async {
                self.images.append(image)
                self.collectionView.reloadData()
            }
        }

        session.loadObjects(ofClass: NSURL.self) { nsurl in
            if let url = nsurl.first as? URL {
                self.imageFetcher.fetch(url)
            }
        }

        session.loadObjects(ofClass: UIImage.self) { images in
            if let image = images.first as? UIImage {
                self.imageFetcher.backup = image
            }
        }

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
        let imageSize = images[indexPath.row].size
        let imageRatio = imageSize.height / imageSize.width

        return CGSize(width: 200, height: 200 * imageRatio)
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



