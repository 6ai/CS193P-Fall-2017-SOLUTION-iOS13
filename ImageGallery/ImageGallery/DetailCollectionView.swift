//
//  ViewController.swift
//  ImageGallery
//
//  Created by ccoleridge on 10/04/2020.
//  Copyright © 2020 ccoleridge. All rights reserved.
//

import UIKit


class DetailCollectionView: UICollectionViewController,
        UICollectionViewDragDelegate,
        UICollectionViewDropDelegate {

    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession
            , at indexPath: IndexPath) -> [UIDragItem] {
        session.localContext = collectionView
        return dragItem(at: indexPath)
    }

    func collectionView(_ collectionView: UICollectionView, canHandle session: UIDropSession) -> Bool {
        return session.canLoadObjects(ofClass: UIImage.self)
    }

    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession,
                        withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
        let isSelf = (session.localDragSession as? UICollectionView) == collectionView
        return UICollectionViewDropProposal(operation: isSelf ? .move : .copy, intent: .insertAtDestinationIndexPath)
    }

    private func dragItem(at indexPath: IndexPath) -> [UIDragItem] {
        if let image = (collectionView.cellForItem(at: indexPath) as? ImageGalleryCollectionViewCell)?.image {
            let dragItem = UIDragItem(itemProvider: NSItemProvider(object: image))
            dragItem.localObject = image
            return [dragItem]
        } else {
            return []
        }
    }

    func collectionView(_ collectionView: UICollectionView, itemsForAddingTo session: UIDragSession,
                        at indexPath: IndexPath, point: CGPoint) -> [UIDragItem] {
        return dragItem(at: indexPath)
    }

    func collectionView(
            _ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        let destinationIndexPath = coordinator.destinationIndexPath ?? IndexPath(item: 0, section: 0)
        for item in coordinator.items {
            if let sourceIndexPath = item.sourceIndexPath,
               let image = item.dragItem.localObject as? UIImage {
                collectionView.performBatchUpdates({
                    images.remove(at: sourceIndexPath.item)
                    images.insert(image, at: destinationIndexPath.item)
                    collectionView.deleteItems(at: [sourceIndexPath])
                    collectionView.insertItems(at: [destinationIndexPath])
                })
                coordinator.drop(item.dragItem, toItemAt: destinationIndexPath)
            } else {
                let placeholderContext = coordinator.drop(
                        item.dragItem, to: UICollectionViewDropPlaceholder(
                        insertionIndexPath: destinationIndexPath, reuseIdentifier: "DropPlaceholderCell"))
                item.dragItem.itemProvider.loadObject(ofClass: UIImage.self) { (provider: NSItemProviderReading?, error: Error?) in
                    if let image = provider as? UIImage {
                        DispatchQueue.main.async {
                            placeholderContext.commitInsertion(dataSourceUpdates:
                            { insertionIndexPath in self.images.insert(image, at: insertionIndexPath.item) })
                        }
                    } else {
                        placeholderContext.deletePlaceholder()
                    }
                }
            }
        }

    }


    fileprivate let cellIdentifier = "imageGalleryCollectionViewCell"
    private var imageFetcher: ImageFetcher!

    var images: [UIImage] = [
        UIImage(named: "Image05")!,
        UIImage(named: "Image03")!,
        UIImage(named: "Image02")!,
        UIImage(named: "Image01")!,
        UIImage(named: "Image04")!,
        UIImage(named: "Image05")!,
    ]

    override func viewDidLoad() {
        super.viewDidLoad()

        configureCollectionView()
    }


    private func configureCollectionView() {
        collectionView.register(ImageGalleryCollectionViewCell.self, forCellWithReuseIdentifier: cellIdentifier)
        collectionView.register(DropPlaceholderCell.self, forCellWithReuseIdentifier: "DropPlaceholderCell")
        collectionView.dragDelegate = self
        collectionView.dropDelegate = self
        collectionView.backgroundColor = .systemPurple
    }

}

// MARK: - UIDropInteractionDelegate

extension DetailCollectionView {
//
//    func dropInteraction(_ interaction: UIDropInteraction, canHandle session: UIDropSession) -> Bool {
//        return session.canLoadObjects(ofClass: NSURL.self) && session.canLoadObjects(ofClass: UIImage.self)
//    }
//
//    func dropInteraction(_ interaction: UIDropInteraction, sessionDidUpdate session: UIDropSession) -> UIDropProposal {
//        return UIDropProposal(operation: .copy)
//    }
//
//    func dropInteraction(_ interaction: UIDropInteraction, performDrop session: UIDropSession) {
//        imageFetcher = ImageFetcher() { (url, image) in
//            DispatchQueue.main.async {
//                self.images.append(image)
//                self.collectionView.reloadData()
//            }
//        }
//
//        session.loadObjects(ofClass: NSURL.self) { nsurl in
//            if let url = nsurl.first as? URL {
//                self.imageFetcher.fetch(url)
//            }
//        }
//
//        session.loadObjects(ofClass: UIImage.self) { images in
//            if let image = images.first as? UIImage {
//                self.imageFetcher.backup = image
//            }
//        }
//
//    }
}

// MARK: - UICollectionViewDataSource

extension DetailCollectionView {
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

// MARK: - UICollectionViewDelegate

extension DetailCollectionView {

}

// MARK: - UICollectionViewDelegateFlowLayout

extension DetailCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let imageSize = images[indexPath.row].size
        let imageRatio = imageSize.height / imageSize.width

        return CGSize(width: 200, height: 200 * imageRatio)
    }

//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
//                        insetForSectionAt section: Int) -> UIEdgeInsets {
//        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
//    }
}


extension UIView {

    func anchor(top: NSLayoutYAxisAnchor? = nil, left: NSLayoutXAxisAnchor? = nil, bottom: NSLayoutYAxisAnchor? = nil,
                right: NSLayoutXAxisAnchor? = nil, paddingTop: CGFloat? = 0, paddingLeft: CGFloat? = 0,
                paddingBottom: CGFloat? = 0, paddingRight: CGFloat? = 0, width: CGFloat? = nil,
                height: CGFloat? = nil) {

        translatesAutoresizingMaskIntoConstraints = false

        if let top = top {
            topAnchor.constraint(equalTo: top, constant: paddingTop ?? 0).isActive = true
        }

        if let left = left {
            leftAnchor.constraint(equalTo: left, constant: paddingLeft ?? 0).isActive = true
        }

        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: -(paddingBottom ?? 0)).isActive = true
        }

        if let right = right {
            rightAnchor.constraint(equalTo: right, constant: -(paddingRight ?? 0)).isActive = true
        }

        if let width = width {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }

        if let height = height {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }
}



