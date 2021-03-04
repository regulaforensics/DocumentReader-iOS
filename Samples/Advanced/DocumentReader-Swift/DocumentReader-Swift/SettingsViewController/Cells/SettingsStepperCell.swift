//
//  SettingsStepperCell.swift
//  DocumentReader-Swift
//
//  Created by Dmitry Evglevsky on 9.02.21.
//  Copyright © 2021 Regula. All rights reserved.
//

import UIKit

protocol SettingsStepperCellDelegate: AnyObject {
    func valueChangedFor(_ item: SettingsIntItem?, _ value: Int) -> Void
}

class SettingsStepperCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var stepperControl: UIStepper!
    @IBOutlet weak var valueLabel: UILabel!
    
    weak var delegate: SettingsStepperCellDelegate? = nil
    var item: SettingsIntItem? = nil {
        didSet {
            guard let item = item else { return }
            titleLabel.text = item.title
            stepperControl.value = Double(item.state())
            valueLabel.text = String(format: item.format, arguments: [item.state()])
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        stepperControl.addTarget(self, action: #selector(stepperAction(_:)),
                                 for: .valueChanged)
    }
    
    @objc func stepperAction(_ sender: UIStepper!) {
        guard let item = item else { return }
        delegate?.valueChangedFor(item, Int(sender.value))
        valueLabel.text = String(format: item.format, arguments: [item.state()])
    }
}
