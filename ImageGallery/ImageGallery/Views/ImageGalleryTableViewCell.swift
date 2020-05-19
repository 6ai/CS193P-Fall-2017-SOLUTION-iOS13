//
// Created by 6ai on 04/05/2020.
// Copyright (c) 2020 6ai. All rights reserved.
//

import UIKit

protocol ImageGalleryTableViewCellDelegate {
    func tableViewCellTextContentDidChange(from oldText: String?, to newText: String?)
}

class ImageGalleryTableViewCell: UITableViewCell, UITextFieldDelegate {
    var delegate: ImageGalleryTableViewCellDelegate!
    let textField: UITextField = {
        let tf = UITextField()
        tf.textAlignment = .center
        tf.backgroundColor = .red
        return tf
    }()

    @objc func cellTappedTwice() {
        textFieldDidBeginEditing(textField)
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        textLabel?.isHidden = true
        textField.isEnabled = true
        textField.becomeFirstResponder()
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        delegate.tableViewCellTextContentDidChange(from: textLabel?.text, to: textField.text)
        textLabel?.isHidden = false
        textField.text = nil
        return true
    }

    private func addDoubleTapGesture() {
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(cellTappedTwice))
        doubleTap.numberOfTapsRequired = 2
        contentView.addGestureRecognizer(doubleTap)
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        // fixme memory cycle
        textField.delegate = self
        backgroundView = textField
        addDoubleTapGesture()
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