//
//  ViewController.swift
//  ImageGallery
//
//  Created by 6ai on 10/04/2020.
//  Copyright © 2020 6ai. All rights reserved.
//

import UIKit


class ImageGalleryController: UICollectionViewController, UICollectionViewDragDelegate, UICollectionViewDropDelegate {

    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated); super.viewWillDisappear(animated)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let url: URL = images[indexPath.row].url
        segueToImageDetail(with: url)
    }

    func segueToImageDetail(with url: URL) {
        let imageDetailController = ImageDetailController()
        imageDetailController.imageURL = url
        navigationController?.pushViewController(imageDetailController, animated: true)
    }

    private var images: [Image] = []

    private let cellIdentifier = "imageGalleryCollectionViewCell"

    private var fetcher: ImageFetcher = ImageFetcher.shared

    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
    }


    private func configureCollectionView() {
        collectionView.register(ImageCell.self, forCellWithReuseIdentifier: cellIdentifier)
        collectionView.dragDelegate = self
        collectionView.dropDelegate = self
        collectionView.backgroundColor = .systemPurple
    }

}

// MARK: - UICollectionViewDataSource

extension ImageGalleryController {
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath)
                    -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: cellIdentifier, for: indexPath as IndexPath) as! ImageCell
        cell.imageURL = images[indexPath.row].url
        return cell
    }

    override func collectionView(_ collectionView: UICollectionView,
                                 numberOfItemsInSection section: Int) -> Int { images.count }
}

// MARK: - UICollectionViewDelegate

extension ImageGalleryController {

}

// MARK: - UICollectionViewDelegateFlowLayout

extension ImageGalleryController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let image = images[indexPath.row]
        let imageRatio = image.height / image.width
        return CGSize(width: 200, height: 200 * imageRatio)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
}

// MARK: - Collection View Drag and Drop

extension ImageGalleryController {

    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession,
                        at indexPath: IndexPath) -> [UIDragItem] {
        session.localContext = collectionView
        return dragItem(at: indexPath)
    }

    func collectionView(_ collectionView: UICollectionView, itemsForAddingTo session: UIDragSession,
                        at indexPath: IndexPath, point: CGPoint) -> [UIDragItem] {
        return dragItem(at: indexPath)
    }

    func collectionView(_ collectionView: UICollectionView, canHandle session: UIDropSession) -> Bool {
        let isSelf = (session.localDragSession?.localContext as? UICollectionView) == collectionView
        return isSelf ? session.canLoadObjects(ofClass: UIImage.self) :
                (session.canLoadObjects(ofClass: NSURL.self) && session.canLoadObjects(ofClass: UIImage.self))
    }

    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession,
                        withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
        let isSelf = (session.localDragSession?.localContext as? UICollectionView) == collectionView
        return UICollectionViewDropProposal(operation: isSelf ? .move : .copy, intent: .insertAtDestinationIndexPath)
    }

    private func dragItem(at indexPath: IndexPath) -> [UIDragItem] {
        guard let itemCell = collectionView?.cellForItem(at: indexPath) as? ImageCell,
              let image = itemCell.image else { return [] }
        let provider = NSItemProvider(object: image)
        let dragItem = UIDragItem(itemProvider: provider)
        dragItem.localObject = images[indexPath.item]
        return [dragItem]

    }

    func collectionView(_ collectionView: UICollectionView,
                        performDropWith coordinator: UICollectionViewDropCoordinator) {
        let destinationIndexPath = coordinator.destinationIndexPath ?? IndexPath(item: 0, section: 0)
        for item in coordinator.items {
            // Local drag and drop behavior
            if let sourceIndexPath = item.sourceIndexPath, let image = item.dragItem.localObject as? Image {
                collectionView.performBatchUpdates({
                    images.remove(at: sourceIndexPath.item)
                    images.insert(image, at: destinationIndexPath.item)
                    collectionView.deleteItems(at: [sourceIndexPath])
                    collectionView.insertItems(at: [destinationIndexPath])
                })
                coordinator.drop(item.dragItem, toItemAt: destinationIndexPath)
            } else {
                // Drag and drop between apps
                let placeholderContext = coordinator.drop(
                        item.dragItem,
                        to: UICollectionViewDropPlaceholder(
                                insertionIndexPath: destinationIndexPath,
                                reuseIdentifier: cellIdentifier
                        )
                )

                var dropImageWidth: CGFloat?
                var dropImageHeight: CGFloat?
                // todo for pictures with high resolution
                item.dragItem.itemProvider.loadObject(ofClass: UIImage.self) { (provider, error) in
                    DispatchQueue.main.async {
                        if let image = provider as? UIImage {
                            dropImageHeight = image.size.height
                            dropImageWidth = image.size.width
                            print(1, dropImageHeight)
                        }
                    }
                }

                item.dragItem.itemProvider.loadObject(ofClass: NSURL.self) { (provider, error) in
                    DispatchQueue.main.async {
                        print(2, dropImageHeight)
                        if let url = provider as? URL, let dropImageWidth = dropImageWidth, let dropImageHeight = dropImageHeight {
                            let image = Image(width: dropImageWidth, height: dropImageHeight, url: url.imageURL)

                            placeholderContext.commitInsertion(dataSourceUpdates: { insertionIndexPath in
                                self.images.insert(image, at: insertionIndexPath.item)
                            })
                        } else {
                            placeholderContext.deletePlaceholder()
                        }
                    }
                }
            }
        }

    }

}
