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
            let size = newValue?.size ?? CGSize.zero
            scrollView.contentSize = size

            scrollViewHeight?.constant = size.height
            scrollViewWidth?.constant = size.width

        }
    }

    private var scrollViewWidth: NSLayoutConstraint?
    private var scrollViewHeight: NSLayoutConstraint?

    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.minimumZoomScale = 1 / 25
        scrollView.maximumZoomScale = 2
        return scrollView
    }()

    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }

    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        scrollViewWidth?.constant = scrollView.contentSize.width
        scrollViewHeight?.constant = scrollView.contentSize.height
    }

    override func viewDidLoad() {
        print(#function)
        super.viewDidLoad()
        view.addSubview(scrollView)
        scrollView.addSubview(imageView)

        scrollView.delegate = self
        setupAutolayout()
    }

    private func setupAutolayout() {
        print(#function)
        scrollView.translatesAutoresizingMaskIntoConstraints = false

        let imageViewSize = imageView.frame.size

        scrollViewWidth = scrollView.widthAnchor.constraint(equalToConstant: imageViewSize.width)
        scrollViewHeight = scrollView.heightAnchor.constraint(equalToConstant: imageViewSize.height)

        scrollViewWidth?.isActive = true
        scrollViewHeight?.isActive = true

        NSLayoutConstraint.activate([
            scrollView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            scrollView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])

    }
}
