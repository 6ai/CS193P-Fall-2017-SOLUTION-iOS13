//
// Created by nattle on 09/03/2020.
// Copyright (c) 2020 Annette. All rights reserved.
//

import UIKit

class GameCardButton: UIButton {
    required init?(coder: NSCoder) {
        super.init(coder: coder)

        backgroundColor = UIColor.groupTableViewBackground
        titleLabel?.font = UIFont.boldSystemFont(ofSize: 32)
        layer.cornerRadius = 8.0
        titleLabel?.numberOfLines = 0
    }
}
