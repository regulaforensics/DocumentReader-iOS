//
//  ImageTableViewCell.swift
//  mDLSample
//
//  Created by Dmitry Evglevsky on 20.12.25.
//  Copyright © 2025 Regula. All rights reserved.
//

import UIKit

class ImageTableViewCell: UITableViewCell {
    @IBOutlet weak var graphicResultImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
