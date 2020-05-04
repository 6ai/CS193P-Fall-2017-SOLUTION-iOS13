//
//  ViewController.swift
//  ImageGallery
//
//  Created by 6ai on 10/04/2020.
//  Copyright © 2020 6ai. All rights reserved.
//

import UIKit


class ImageGalleryCollectionViewController: UICollectionViewController {

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
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
        let imageDetailController = ImageController()
        imageDetailController.imageURL = url
        navigationController?.pushViewController(imageDetailController, animated: true)
    }

    private var images: [Image] = []
    private var cellWidth: CGFloat = 200 {
        didSet { collectionView.reloadData() }
    }

    @objc private func scaleCellWidth(_ recognizer: UIPinchGestureRecognizer) {
        // todo pitch gesture works
        switch recognizer.state {
        case .ended: break
        default: break
        }
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
    }

    private func configureCollectionView() {
        collectionView.register(ImageGalleryCollectionViewCell.self,
                forCellWithReuseIdentifier: ImageGalleryCollectionViewCell.identifier)
        collectionView.dragDelegate = self
        collectionView.dropDelegate = self

        let pinch = UIPinchGestureRecognizer(target: self, action: #selector(scaleCellWidth))
        collectionView.addGestureRecognizer(pinch)
        collectionView.backgroundColor = .systemPurple
    }

}

// MARK: - UICollectionViewDataSource

extension ImageGalleryCollectionViewController {
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath)
                    -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: ImageGalleryCollectionViewCell.identifier,
                for: indexPath as IndexPath) as! ImageGalleryCollectionViewCell
        cell.imageURL = images[indexPath.row].url
        return cell
    }

    override func collectionView(_ collectionView: UICollectionView,
                                 numberOfItemsInSection section: Int) -> Int { images.count }
}

// MARK: - UICollectionViewDelegate

extension ImageGalleryCollectionViewController {

}

// MARK: - UICollectionViewDelegateFlowLayout

extension ImageGalleryCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let imageAspectRatio = images[indexPath.row].aspectRatio
        return CGSize(width: cellWidth, height: cellWidth * imageAspectRatio)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
}

// MARK: - UICollectionViewDragDelegate

extension ImageGalleryCollectionViewController: UICollectionViewDragDelegate {

    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession,
                        at indexPath: IndexPath) -> [UIDragItem] {
        session.localContext = collectionView
        return dragItem(at: indexPath)
    }

    func collectionView(_ collectionView: UICollectionView, itemsForAddingTo session: UIDragSession,
                        at indexPath: IndexPath, point: CGPoint) -> [UIDragItem] { dragItem(at: indexPath) }

    func collectionView(_ collectionView: UICollectionView, canHandle session: UIDropSession) -> Bool {
        let isSelf = (session.localDragSession?.localContext as? UICollectionView) == collectionView
        return isSelf ? session.canLoadObjects(ofClass: UIImage.self) :
                (session.canLoadObjects(ofClass: NSURL.self) && session.canLoadObjects(ofClass: UIImage.self))
    }

    private func dragItem(at indexPath: IndexPath) -> [UIDragItem] {
        guard let itemCell = collectionView?.cellForItem(at: indexPath) as? ImageGalleryCollectionViewCell,
              let image = itemCell.image else { return [] }
        let provider = NSItemProvider(object: image)
        let dragItem = UIDragItem(itemProvider: provider)
        dragItem.localObject = images[indexPath.item]
        return [dragItem]

    }
}

// MARK: - UICollectionViewDropDelegate

extension ImageGalleryCollectionViewController: UICollectionViewDropDelegate {

    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession,
                        withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
        let isSelf = (session.localDragSession?.localContext as? UICollectionView) == collectionView
        return UICollectionViewDropProposal(operation: isSelf ? .move : .copy, intent: .insertAtDestinationIndexPath)
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
                let placeholder = UICollectionViewDropPlaceholder(insertionIndexPath: destinationIndexPath,
                        reuseIdentifier: ImageGalleryCollectionViewCell.identifier)
                let placeholderContext = coordinator.drop(item.dragItem, to: placeholder)
                var dropImageAspectRatio: CGFloat?

                // todo for pictures with high resolution
                // Extract image from item provider
                item.dragItem.itemProvider.loadObject(ofClass: UIImage.self) { (provider, error) in
                    DispatchQueue.main.async {
                        if let image = provider as? UIImage {
                            dropImageAspectRatio = image.size.height / image.size.width
                        }
                    }
                }
                // Extract url from item provider
                item.dragItem.itemProvider.loadObject(ofClass: NSURL.self) { (provider, error) in
                    DispatchQueue.main.async {
                        if let url = provider as? URL, let dropImageAspectRatio = dropImageAspectRatio {
                            let image = Image(url: url.imageURL, aspectRatio: dropImageAspectRatio)
                            placeholderContext.commitInsertion(dataSourceUpdates: { insertionIndexPath in
                                self.images.insert(image, at: insertionIndexPath.item)
                            })
                        } else {
                            print("Image drop field")
                            placeholderContext.deletePlaceholder()
                        }
                    }
                }
            }
        }
    }

}
