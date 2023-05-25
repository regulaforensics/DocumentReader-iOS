//
//  GetValuesViewController.swift
//  DocumentReader-Swift
//
//  Created by Dmitry Evglevsky on 11.02.21.
//  Copyright © 2021 Regula. All rights reserved.
//

import UIKit
import DocumentReader
import SafariServices

class GetValuesViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var addSwitch: UISwitch!
    @IBOutlet weak var resultLabel: UITextField!
    
    var results: DocumentReaderResults? = nil
    
    private var selectedFieldIndex: Int = 0
    private var fields: [ParameterField] = []
    private var parameters: Parameter = [.fieldType]
    private var functionFormat: String {
        functionFormat(with: parameters)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pickerView.dataSource = self
        pickerView.delegate = self
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.layer.borderWidth = 1

        setupFields()
        tableView.reloadData()
        tableView.selectRow(at: IndexPath(row: selectedFieldIndex, section: 0), animated: true, scrollPosition: .top)
        textView.text = functionText()
        
        let helpBarButton = UIBarButtonItem(title: "Help", style: .plain, target: self, action: #selector(helpButtonAction(_:)))
        navigationItem.rightBarButtonItem = helpBarButton
    }
    
    @objc func helpButtonAction(_ sender: UIBarButtonItem) {
        let link = "https://docs.regulaforensics.com/develop/doc-reader-sdk/mobile/ios/results"
    
        guard let url = URL(string: link) else { return }
        let controller = SFSafariViewController(url: url)
        present(controller, animated: true, completion: nil)
    }
    
    @IBAction func addSwitchAction(_ sender: UISwitch) {
        fields[selectedFieldIndex].isOn = sender.isOn
        
        if (selectedFieldIndex != 0) {
            tableView.isUserInteractionEnabled = sender.isOn ? true : false
            tableView.alpha = sender.isOn ? 1 : 0.5
        }
        
        textView.text = functionText()
    }

    private func setupFields() {
        guard let results = results else { return }
        
        let fieldType = ParameterField("fieldType", true, .fieldType)
        fieldType.presentedItems = Array(Set(results.textResult.fields.compactMap { $0.fieldType.rawValue }))
        fieldType.items = FieldType.allCases.compactMap { $0.rawValue }
        sortFieldItems(field: fieldType)
        
        let lcid = ParameterField("lcid", false, .lcid)
        lcid.presentedItems = Array(Set(results.textResult.fields.compactMap { $0.lcid.rawValue }))
        lcid.items = LCID.allCases.compactMap { $0.rawValue }
        sortFieldItems(field: lcid)
        
        let source = ParameterField("source", false, .sourceType)
        let sources = results.textResult.fields.compactMap { $0.values }.flatMap { $0 }.compactMap { $0.sourceType.rawValue }
        source.presentedItems = Array(Set(sources))
        source.items = ResultType.allCases.compactMap { $0.rawValue }
        sortFieldItems(field: source)
        
        let original = ParameterField("original", false, .original)
        original.items = [0, 1]
        
        fields.removeAll()
        fields.append(contentsOf: [fieldType, lcid, source, original])
    }
    
    private func sortFieldItems(field: ParameterField) {
        let notPresented = Set(field.items).subtracting(field.presentedItems)
        field.items = field.presentedItems.sorted() + notPresented.sorted()
    }
    
    private func indicesFromFields() -> [Int] {
        var indices: [Int] = []
        for index in 0..<fields.count {
            if fields[index].isOn {
                indices.append(index)
            }
        }
        return indices
    }
    
    private func argumentsValues(with indices: [Int]) -> [Int] {
        var arguments: [Int] = []
        for index in indices {
            let selectedIndex = fields[index].selectedItem
            let intValue = fields[index].items[selectedIndex]
            arguments.append(intValue)
        }
        return arguments
    }
    
    private func arguments(with indices: [Int]) -> [String] {
        var arguments: [String] = []
        for index in indices {
            let selectedIndex = fields[index].selectedItem
            let intValue = fields[index].items[selectedIndex]
            let arg = argument(with: fields[index].parameter, with: intValue)
            arguments.append(arg)
        }
        return arguments
    }
    
    private func argument(with parameters: Parameter, with intValue: Int) -> String {
        switch parameters {
        case .fieldType:
            return FieldType(rawValue: intValue)?.stringValue ?? "n/a"
        case .lcid:
            return LCID(rawValue: intValue)?.stringValue ?? "n/a"
        case .sourceType:
            return ResultType(rawValue: intValue)?.stringValue ?? "n/a"
        case .original:
            return (intValue == 0) ? "false" : "true"
        default:
            break
        }
        return "n/a"
    }
    
    private func functionFormat(with parameters: Parameter) -> String {
        var format = "Unknown configuration"
        switch parameters {
        case .fieldType:
            format = "getTextFieldValueByType(fieldType: %@)"
        case .fieldType_lcid:
            format = "getTextFieldValueByType(fieldType: %@, lcid: %@)"
        case .fieldType_lcid_sourceType:
            format = "getTextFieldValueByType(fieldType: %@, lcid: %@, source: %@)"
        case .fieldType_lcid_sourceType_original:
            format = "getTextFieldValueByType(fieldType: %@, lcid: %@, source: %@, original: %@)"
        case .fieldType_sourceType:
            format = "getTextFieldValueByType(fieldType: %@, source: %@)"
        case .fieldType_sourceType_original:
            format = "getTextFieldValueByType(fieldType: %@, source: %@, original: %@)"
        case .fieldType_original:
            format = "getTextFieldValueByType(fieldType: %@, original: %@)"
        default:
            break
        }
        return format
    }
    
    private func functionOutput(with paramaters: Parameter, args: [Int]) -> String {
        guard let results = results else { return "n/a" }
        var output = "n/a"
        switch parameters {
        case .fieldType:
            if let arg0 = FieldType(rawValue: args[0]) {
                output = results.getTextFieldByType(fieldType: arg0)?.getValue()?.value ?? "n/a"
            }
        case .fieldType_lcid:
            if let arg0 = FieldType(rawValue: args[0]),
               let arg1 = LCID(rawValue: args[1]) {
                output = results.getTextFieldByType(fieldType: arg0, lcid: arg1)?.getValue()?.value ?? "n/a"
            }
        case .fieldType_lcid_sourceType:
            if let arg0 = FieldType(rawValue: args[0]),
               let arg1 = LCID(rawValue: args[1]),
               let arg2 = ResultType(rawValue: args[2]) {
                output = results.getTextFieldValueByType(fieldType: arg0, lcid: arg1, source: arg2) ?? "n/a"
            }
        case .fieldType_lcid_sourceType_original:
            if let arg0 = FieldType(rawValue: args[0]),
               let arg1 = LCID(rawValue: args[1]),
               let arg2 = ResultType(rawValue: args[2]) {
                let arg3 = (args[3] == 0) ? false : true
                output = results.getTextFieldValueByType(fieldType: arg0, lcid: arg1, source: arg2, original: arg3) ?? "n/a"
            }
        case .fieldType_sourceType:
            if let arg0 = FieldType(rawValue: args[0]),
               let arg1 = ResultType(rawValue: args[1]) {
                output = results.getTextFieldValueByType(fieldType: arg0, source: arg1) ?? "n/a"
            }
        case .fieldType_sourceType_original:
            if let arg0 = FieldType(rawValue: args[0]),
               let arg1 = ResultType(rawValue: args[1]) {
                let arg2 = (args[2] == 0) ? false : true
                output = results.getTextFieldValueByType(fieldType: arg0, source: arg1, original: arg2) ?? "n/a"
            }
        case .fieldType_original:
            if let arg0 = FieldType(rawValue: args[0]) {
                let arg1 = (args[1] == 0) ? false : true
                output = results.getTextFieldValueByType(fieldType: arg0, original: arg1) ?? "n/a"
            }
        default:
            break
        }
        return output
    }
    
    private func functionText() -> String {
        let indices: [Int] = indicesFromFields()
        parameters = Parameter.made(with: indices)
        
        let args = arguments(with: indices)
        let output = String(format: functionFormat, arguments: args)
        
        if output != "Unknown configuration" {
            let argsInt = argumentsValues(with: indices)
            let text = functionOutput(with: parameters, args: argsInt)
            
            resultLabel.text = text
        }
        
        return output
    }
}

// MARK: - UIPickerViewDelegate & UIPickerViewDataSource

extension GetValuesViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        fields.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        fields[row].title
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedFieldIndex = row
        
        let isOn = fields[row].isOn
        addSwitch.setOn(isOn, animated: true)
        addSwitch.isEnabled = (row != 0) // fieldType always as parameter
        
        tableView.isUserInteractionEnabled = isOn ? true : false
        tableView.alpha = isOn ? 1 : 0.5
        
        let selectionRow = fields[row].selectedItem
        tableView.reloadData()
        let selectionPath = IndexPath(row: selectionRow, section: 0)
        tableView.selectRow(at: selectionPath, animated: true, scrollPosition: .top)
    }
}

// MARK: - UITableViewDelegate & UITableViewDataSource

extension GetValuesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let field = fields[selectedFieldIndex]
        return field.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let field = fields[selectedFieldIndex]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: kFieldCellId, for: indexPath)
        let rawValue = field.items[indexPath.row]
        cell.textLabel?.text = argument(with: field.parameter, with: rawValue)
        
        if field.presentedItems.contains(rawValue) {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let field = fields[selectedFieldIndex]
        field.selectedItem = indexPath.row
        textView.text = functionText()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        44
    }
}
