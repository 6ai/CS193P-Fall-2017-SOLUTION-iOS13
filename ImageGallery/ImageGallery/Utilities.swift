//
//  Utilities.swift
//
//  Created by CS193p Instructor.
//  Copyright © 2017 Stanford University. All rights reserved.
//

import UIKit

// Simple image fetcher without backup
class ImageFetcher {
    private init() {}

    static var shared: ImageFetcher {
        let fetcher = ImageFetcher()
        return fetcher
    }

    func fetchImage(with url: URL) -> UIImage? {
        // todo async fetcher with completion handler
        guard let urlContents = try? Data(contentsOf: url.imageURL) else { return nil }
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

extension UIImage {
    private static let localImagesDirectory = "UIImage.storeLocallyAsJPEG"

    static func urlToStoreLocallyAsJPEG(named: String) -> URL? {
        var name = named
        let pathComponents = named.components(separatedBy: "/")
        if pathComponents.count > 1 {
            if pathComponents[pathComponents.count - 2] == localImagesDirectory {
                name = pathComponents.last!
            } else {
                return nil
            }
        }
        if var url = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first {
            url = url.appendingPathComponent(localImagesDirectory)
            do {
                try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true)
                url = url.appendingPathComponent(name)
                if url.pathExtension != "jpg" {
                    url = url.appendingPathExtension("jpg")
                }
                return url
            } catch let error {
                print("UIImage.urlToStoreLocallyAsJPEG \(error)")
            }
        }
        return nil
    }

    func storeLocallyAsJPEG(named name: String) -> URL? {
        if let imageData = self.jpegData(compressionQuality: 1.0) {
            if let url = UIImage.urlToStoreLocallyAsJPEG(named: name) {
                do {
                    try imageData.write(to: url)
                    return url
                } catch let error {
                    print("UIImage.storeLocallyAsJPEG \(error)")
                }
            }
        }
        return nil
    }
}

extension String {
    func madeUnique(withRespectTo otherStrings: [String]) -> String {
        var possiblyUnique = self
        var uniqueNumber = 1
        while otherStrings.contains(possiblyUnique) {
            possiblyUnique = self + " \(uniqueNumber)"
            uniqueNumber += 1
        }
        return possiblyUnique
    }
}

extension Array where Element: Equatable {
    var uniquified: [Element] {
        var elements = [Element]()
        forEach {
            if !elements.contains($0) {
                elements.append($0)
            }
        }
        return elements
    }
}

extension NSAttributedString {
    func withFontScaled(by factor: CGFloat) -> NSAttributedString {
        let mutable = NSMutableAttributedString(attributedString: self)
        mutable.setFont(mutable.font?.scaled(by: factor))
        return mutable
    }

    var font: UIFont? {
        get {
            return attribute(.font, at: 0, effectiveRange: nil) as? UIFont
        }
    }
}

extension String {
    func attributedString(withTextStyle style: UIFont.TextStyle, ofSize size: CGFloat) -> NSAttributedString {
        let font = UIFontMetrics(forTextStyle: .body).scaledFont(for: UIFont.preferredFont(forTextStyle: .body).withSize(size))
        return NSAttributedString(string: self, attributes: [.font: font])
    }
}

extension NSMutableAttributedString {
    func setFont(_ newValue: UIFont?) {
        if newValue != nil {
            addAttributes([.font: newValue!], range: NSMakeRange(0, length))
        }
    }
}

extension UIFont {
    func scaled(by factor: CGFloat) -> UIFont {
        return withSize(pointSize * factor)
    }
}

extension UILabel {
    func stretchToFit() {
        let oldCenter = center
        sizeToFit()
        center = oldCenter
    }
}

extension CGPoint {
    func offset(by delta: CGPoint) -> CGPoint {
        return CGPoint(x: x + delta.x, y: y + delta.y)
    }
}

extension UIViewController {
    var contents: UIViewController {
        if let navcon = self as? UINavigationController {
            return navcon.visibleViewController ?? navcon
        } else {
            return self
        }
    }
}

extension UIView {
    var snapshot: UIImage? {
        UIGraphicsBeginImageContext(bounds.size)
        drawHierarchy(in: bounds, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}

extension UIView {

    func anchor(top: NSLayoutYAxisAnchor? = nil, left: NSLayoutXAxisAnchor? = nil, bottom: NSLayoutYAxisAnchor? = nil,
                right: NSLayoutXAxisAnchor? = nil, paddingTop: CGFloat? = 0, paddingLeft: CGFloat? = 0,
                paddingBottom: CGFloat? = 0, paddingRight: CGFloat? = 0, width: CGFloat? = nil,
                height: CGFloat? = nil) {

        translatesAutoresizingMaskIntoConstraints = false

        if let top = top {
            topAnchor.constraint(equalTo: top, constant: paddingTop ?? 0).isActive = true
        }

        if let left = left {
            leftAnchor.constraint(equalTo: left, constant: paddingLeft ?? 0).isActive = true
        }

        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: -(paddingBottom ?? 0)).isActive = true
        }

        if let right = right {
            rightAnchor.constraint(equalTo: right, constant: -(paddingRight ?? 0)).isActive = true
        }

        if let width = width {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }

        if let height = height {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }
}
