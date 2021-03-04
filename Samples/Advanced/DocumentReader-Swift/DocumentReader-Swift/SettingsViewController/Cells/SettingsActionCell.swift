//
//  SettingsActionCell.swift
//  DocumentReader-Swift
//
//  Created by Dmitry Evglevsky on 10.02.21.
//  Copyright © 2021 Regula. All rights reserved.
//

import UIKit

protocol SettingsActionCellDelegate: AnyObject {
    func actionFor(_ item: SettingsActionItem?) -> Void
}

class SettingsActionCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    
    weak var delegate: SettingsActionCellDelegate? = nil
    var item: SettingsActionItem? = nil {
        didSet {
            guard let item = item else { return }
            titleLabel.text = item.title
            valueLabel.text = item.state()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapGestureAction(_:)))
        addGestureRecognizer(tapGesture)
    }
    
    @objc func tapGestureAction(_ sender: UITapGestureRecognizer) {
        item?.action()
    }
}
