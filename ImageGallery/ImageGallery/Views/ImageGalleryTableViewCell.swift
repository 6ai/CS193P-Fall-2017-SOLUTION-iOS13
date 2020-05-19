//
// Created by 6ai on 04/05/2020.
// Copyright (c) 2020 6ai. All rights reserved.
//

import UIKit

protocol ImageGalleryTableViewCellDelegate {
    func tableViewCellTextLabelDidChange(from: String, to: String)
}

class ImageGalleryTableViewCell: UITableViewCell, UITextFieldDelegate {
    var delegate: ImageGalleryTableViewCellDelegate!
    let textField: UITextField = {
        let tf = UITextField()
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(textFieldDidBeginEditing))
        doubleTap.numberOfTapsRequired = 2
        tf.textAlignment = .center
//        tf.addGestureRecognizer(doubleTap)
        tf.backgroundColor = .red
        return tf
    }()

    @objc func cellTappedTwice() {
        textFieldDidBeginEditing(textField)
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        textLabel?.text = ""
        textField.isEnabled = true
        textField.becomeFirstResponder()
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        delegate.tableViewCellTextLabelDidChange(from: "", to: textField.text ?? "")
//        textField
//        textLabel?.text = textField.text
        return true
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        textField.delegate = self
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(cellTappedTwice))
        doubleTap.numberOfTapsRequired = 2
        contentView.addGestureRecognizer(doubleTap)
        backgroundView = textField
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension UITableViewCell: CellIdentifiable {
    static var identifier: String {
        get { String(describing: Self.self) }
    }
}