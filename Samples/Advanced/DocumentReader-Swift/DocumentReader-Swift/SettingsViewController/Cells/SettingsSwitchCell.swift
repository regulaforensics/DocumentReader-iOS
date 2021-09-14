//
//  SettingsSwitchCell.swift
//  DocumentReader-Swift
//
//  Created by Dmitry Evglevsky on 9.02.21.
//  Copyright © 2021 Regula. All rights reserved.
//

import UIKit

protocol SettingsSwitchCellDelegate: AnyObject {
    func stateChangedFor(_ item: SettingsBoolItem?, _ isOn: Bool) -> Void
}

class SettingsSwitchCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var switchControl: UISwitch!
    
    weak var delegate: SettingsSwitchCellDelegate? = nil
    var item: SettingsBoolItem? = nil {
        didSet {
            guard let item = item else { return }
            titleLabel.text = item.title
            switchControl.setOn(item.getter(), animated: true)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        switchControl.addTarget(self, action: #selector(switchAction(_:)),
                                for: .valueChanged)
    }
    
    @objc func switchAction(_ sender: UISwitch!) {
        delegate?.stateChangedFor(item, sender.isOn)
    }
}
