//
// Created by 6ai on 03/05/2020.
// Copyright (c) 2020 6ai. All rights reserved.
//

import UIKit

class Image {
    let width: CGFloat
    let height: CGFloat

    let url: URL

    init(width: CGFloat, height: CGFloat, url: URL) {
        self.width = width
        self.height = height
        self.url = url
    }
}
