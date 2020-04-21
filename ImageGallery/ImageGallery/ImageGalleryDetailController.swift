//
//  ViewController.swift
//  ImageGallery
//
//  Created by ccoleridge on 10/04/2020.
//  Copyright © 2020 ccoleridge. All rights reserved.
//

import UIKit


class ImageGalleryDetailController: UICollectionViewController, UICollectionViewDragDelegate, UICollectionViewDropDelegate {

    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession,
                        at indexPath: IndexPath) -> [UIDragItem] {
        print(#function)
        session.localContext = collectionView
        return dragItem(at: indexPath)
    }

    func collectionView(_ collectionView: UICollectionView, itemsForAddingTo session: UIDragSession,
                        at indexPath: IndexPath, point: CGPoint) -> [UIDragItem] {
        print(#function)
        return dragItem(at: indexPath)
    }

    func collectionView(_ collectionView: UICollectionView, canHandle session: UIDropSession) -> Bool {
        print(#function, session.canLoadObjects(ofClass: UIImage.self), session.canLoadObjects(ofClass: NSURL.self))
        return session.canLoadObjects(ofClass: URL.self)
    }

    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession,
                        withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
        print(#function)
        let isSelf = (session.localDragSession as? UICollectionView) == collectionView
        return UICollectionViewDropProposal(operation: isSelf ? .move : .copy, intent: .insertAtDestinationIndexPath)
    }

    private func dragItem(at indexPath: IndexPath) -> [UIDragItem] {
        if let image = fetcher.fetchImage(with: imagesURL[indexPath.row]) {
            print(#function)
            let dragItem = UIDragItem(itemProvider: NSItemProvider(object: image))
            dragItem.localObject = image
            return [dragItem]
        } else {
            return []
        }
    }


    func collectionView(
            _ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        let destinationIndexPath = coordinator.destinationIndexPath ?? IndexPath(item: 0, section: 0)
        print(#function)
        for item in coordinator.items {
            if let sourceIndexPath = item.sourceIndexPath,
               // Local drag and drop behavior
               let url = item.dragItem.localObject as? URL {
                collectionView.performBatchUpdates({
                    imagesURL.remove(at: sourceIndexPath.item)
                    imagesURL.insert(url, at: destinationIndexPath.item)
                    collectionView.deleteItems(at: [sourceIndexPath])
                    collectionView.insertItems(at: [destinationIndexPath])
                })
                coordinator.drop(item.dragItem, toItemAt: destinationIndexPath)
            } else {
                // Drag and drop between apps
                let placeholderContext = coordinator.drop(
                        item.dragItem, to: UICollectionViewDropPlaceholder(
                        insertionIndexPath: destinationIndexPath, reuseIdentifier: cellIdentifier))
                item.dragItem.itemProvider.loadObject(ofClass: UIImage.self) {
                    (provider: NSItemProviderReading?, error: Error?) in
                    if let url = provider as? URL {
                        DispatchQueue.main.async {
                            placeholderContext.commitInsertion(dataSourceUpdates:
                            { insertionIndexPath in self.imagesURL.insert(url, at: insertionIndexPath.item) })
                        }
                    } else {
                        placeholderContext.deletePlaceholder()
                    }
                }
            }
        }

    }


    fileprivate let cellIdentifier = "imageGalleryCollectionViewCell"
    private var fetcher: ImageFetcher = ImageFetcher.shared

    var imagesURL = Images.urls

    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
    }



    private func configureCollectionView() {
        collectionView.register(DetailCollectionViewCell.self, forCellWithReuseIdentifier: cellIdentifier)
        collectionView.dragDelegate = self
        collectionView.dropDelegate = self
        collectionView.backgroundColor = .systemPurple
    }

}

// MARK: - UIDropInteractionDelegate

extension ImageGalleryDetailController {

    func dropInteraction(_ interaction: UIDropInteraction, canHandle session: UIDropSession) -> Bool {
        print(#function, session.canLoadObjects(ofClass: NSURL.self) && session.canLoadObjects(ofClass: UIImage.self))
        return session.canLoadObjects(ofClass: NSURL.self) && session.canLoadObjects(ofClass: UIImage.self)
    }

    func dropInteraction(_ interaction: UIDropInteraction, sessionDidUpdate session: UIDropSession) -> UIDropProposal {
        print(#function)
        return UIDropProposal(operation: .copy)
    }

    func dropInteraction(_ interaction: UIDropInteraction, performDrop session: UIDropSession) {
//        imageFetcher = ImageFetcher() { (url, image) in
//            DispatchQueue.main.async {
//                self.images.append(image)
//                self.collectionView.reloadData()
//            }
//        }

        session.loadObjects(ofClass: NSURL.self) { nsurl in
            if let url = nsurl.first as? URL {
//                self.imageFetcher.fetch(url)
                print(url)
            }
        }

//        session.loadObjects(ofClass: UIImage.self) { images in
//            if let image = images.first as? UIImage {
//                self.imageFetcher.backup = image
//            }
//        }

    }
}

// MARK: - UICollectionViewDataSource

extension ImageGalleryDetailController {
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath)
                    -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: cellIdentifier, for: indexPath as IndexPath) as! DetailCollectionViewCell
        cell.imageURL = imagesURL[indexPath.row]
        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imagesURL.count
    }
}

// MARK: - UICollectionViewDelegate

extension ImageGalleryDetailController {

}

// MARK: - UICollectionViewDelegateFlowLayout

extension ImageGalleryDetailController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {

        if let image = fetcher.fetchImage(with: imagesURL[indexPath.row]) {
            let imageRatio = image.size.height / image.size.width
            return CGSize(width: 200, height: 200 * imageRatio)
        }
        return .zero
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
}



