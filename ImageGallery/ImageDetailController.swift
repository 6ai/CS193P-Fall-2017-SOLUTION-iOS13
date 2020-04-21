//
// Created by ccoleridge on 21/04/2020.
// Copyright (c) 2020 ccoleridge. All rights reserved.
//

import UIKit

class ImageDetailController: UIViewController, UIScrollViewDelegate {
    var imageView = UIImageView()
    var image: UIImage? {
        get {
            return imageView.image
        }
        set {
            imageView.image = newValue
            imageView.sizeToFit()
            scrollView.contentSize = imageView.frame.size
        }
    }

    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.minimumZoomScale = 1 / 25
        scrollView.maximumZoomScale = 1.0
        return scrollView
    }()

    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }

    override func viewDidLoad() {
        print(#function)
        super.viewDidLoad()
        view.addSubview(scrollView)
        scrollView.addSubview(imageView)
        scrollView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor)
        scrollView.delegate = self

    }
}
