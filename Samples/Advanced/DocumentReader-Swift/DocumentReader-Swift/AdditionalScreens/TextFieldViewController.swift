//
//  TextFieldViewController.swift
//  DocumentReader-Swift
//
//  Created by Dmitry Evglevsky on 10.02.21.
//  Copyright © 2021 Regula. All rights reserved.
//

import UIKit

class TextFieldViewController: UIViewController {
    @IBOutlet weak var textField: UITextField!
    
    var isInputForNumbersOnly: Bool = false
    var isSupportNegativeValues: Bool = false
    var placeholder: String = ""
    var initalValue: String = ""
    var completion: ((String) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        addDoneButton()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        completion?(textField.text ?? "")
    }
    
    private func setupUI() {
        textField.placeholder = placeholder
        textField.delegate = self
        textField.text = initalValue
        if isSupportNegativeValues {
            textField.keyboardType = .numbersAndPunctuation
        } else if isInputForNumbersOnly {
            textField.keyboardType = .numberPad
        }
    }
    
    private func addDoneButton() {
        let keyboardToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width,
                                                      height: 44))
        let flexBarButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneBarButton = UIBarButtonItem(barButtonSystemItem: .done, target: self,
                                            action: #selector(doneAction(sender:)))
        keyboardToolbar.items = [flexBarButton, doneBarButton]
        textField.inputAccessoryView = keyboardToolbar
    }
    
    @objc func doneAction(sender: AnyObject) {
        view.endEditing(true)
    }
}

extension TextFieldViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if isInputForNumbersOnly {
            let currentText = textField.text ?? ""
            guard let stringRange = Range(range, in: currentText) else { return false }
            let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
            
            guard !updatedText.isEmpty else { return true }
            let numberFormatter = NumberFormatter()
            numberFormatter.numberStyle = .none
            if isSupportNegativeValues, updatedText.count == 1, updatedText.first == "-" {
                return true
            }
            return numberFormatter.number(from: updatedText)?.intValue != nil
        } else {
            return true
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
