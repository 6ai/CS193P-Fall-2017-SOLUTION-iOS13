//
// Created by 6ai on 22/04/2020.
// Copyright (c) 2020 6ai. All rights reserved.
//

import UIKit

struct Gallery {

    var name: String

    let navigationVC: UINavigationController = {
        let layout = UICollectionViewFlowLayout()
        let controller = ImageGalleryCollectionViewController(collectionViewLayout: layout)
        let navigationVC = UINavigationController(rootViewController: controller)
        return navigationVC
    }()
}
