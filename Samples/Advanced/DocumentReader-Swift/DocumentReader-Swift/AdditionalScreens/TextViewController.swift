//
//  TextViewController.swift
//  DocumentReader-Swift
//
//  Created by Dmitry Evglevsky on 10.02.21.
//  Copyright © 2021 Regula. All rights reserved.
//

import UIKit

class TextViewController: UIViewController {
    @IBOutlet weak var textView: UITextView!
    
    var initalValue: String = ""
    var completion: ((String) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        textView.text = initalValue
        textView.layer.borderWidth = 1
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        completion?(textView.text ?? "")
    }
}
