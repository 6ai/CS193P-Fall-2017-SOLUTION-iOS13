//
// Created by ccoleridge on 20/04/2020.
// Copyright (c) 2020 ccoleridge. All rights reserved.
//

import UIKit

class ImageFetcher {
    private init() {
    }

    static var shared: ImageFetcher {
        let fetcher = ImageFetcher()
        return fetcher
    }

    func fetchImage(with url: URL) -> UIImage? {
        guard let urlContents = try? Data(contentsOf: url.imageURL) else {
            return nil
        }
        return UIImage(data: urlContents)
    }

}

extension URL {
    var imageURL: URL {
        if let url = UIImage.urlToStoreLocallyAsJPEG(named: self.path) {
            // this was created using UIImage.storeLocallyAsJPEG
            return url
        } else {
            // check to see if there is an embedded imgurl reference
            for query in query?.components(separatedBy: "&") ?? [] {
                let queryComponents = query.components(separatedBy: "=")
                if queryComponents.count == 2 {
                    if queryComponents[0] == "imgurl", let url = URL(string: queryComponents[1].removingPercentEncoding ?? "") {
                        return url
                    }
                }
            }
            return self.baseURL ?? self
        }
    }
}
