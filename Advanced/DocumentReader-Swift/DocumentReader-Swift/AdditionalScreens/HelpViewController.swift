//
//  HelpViewController.swift
//  DocumentReader-Swift
//
//  Created by Dmitry Evglevsky on 24.02.21.
//  Copyright © 2021 Regula. All rights reserved.
//

import UIKit

class HelpViewController: UIViewController {
    var infoImage: UIImage? = nil
    var infoText: String? = nil
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.image = infoImage
        textView.text = infoText
    }
    
    @IBAction func closeAction(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}
