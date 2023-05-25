//
//  SettingsActionCell.swift
//  DocumentReader-Swift
//
//  Created by Dmitry Evglevsky on 10.02.21.
//  Copyright © 2021 Regula. All rights reserved.
//

import UIKit

class SettingsActionCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!

    var onPressAction: ((SettingsActionCell) -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapGestureAction(_:)))
        addGestureRecognizer(tapGesture)
    }

    func configure(title: String, value: String) {
        titleLabel.text = title
        valueLabel.text = value
    }
    
    @objc func tapGestureAction(_ sender: UITapGestureRecognizer) {
        onPressAction?(self)
    }
}
