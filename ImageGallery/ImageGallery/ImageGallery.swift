//
// Created by 6ai on 22/04/2020.
// Copyright (c) 2020 6ai. All rights reserved.
//

import UIKit

struct ImageGallery {
    var name: UITextField = UITextField()

    let navigationVC: UINavigationController = {
        let layout = UICollectionViewFlowLayout()
        let controller = ImageGalleryCollectionViewController(collectionViewLayout: layout)
        let navigationVC = UINavigationController(rootViewController: controller)
        return navigationVC
    }()

    init(name: String) {

        self.name.text = name
    }
}

