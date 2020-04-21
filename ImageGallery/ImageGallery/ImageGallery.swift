//
// Created by ccoleridge on 22/04/2020.
// Copyright (c) 2020 ccoleridge. All rights reserved.
//

import UIKit

class ImageGallery {

    let detailViewController: UINavigationController = {
        let layout = UICollectionViewFlowLayout()
        let detailViewController = UINavigationController(rootViewController: ImageGalleryDetailController(collectionViewLayout: layout))
        return detailViewController
    }()

    var imageURL: [URL] = []
    var name: String {
        didSet {
            detailViewController.navigationBar.topItem?.title = name
        }
    }

    init(imageURL: [URL]?, name: String) {
        print("________________", #function)
        self.imageURL = imageURL ?? []
        self.name = name
    }
}
