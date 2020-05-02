//
// Created by 6ai on 22/04/2020.
// Copyright (c) 2020 6ai. All rights reserved.
//

import UIKit

class ImageGallery {

    let navigationVC: UINavigationController = {
        let layout = UICollectionViewFlowLayout()
        let controller = ImageGalleryController(collectionViewLayout: layout)
        let navigationVC = UINavigationController(rootViewController: controller)
        return navigationVC
    }()

    var name: String

    init(name: String) {
        self.name = name
    }
}
