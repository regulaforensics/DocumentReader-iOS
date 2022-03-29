//
//  ResultsViewController.swift
//  DocumentReader-Swift
//
//  Created by Dmitry Evglevsky on 2/4/21.
//  Copyright © 2021 Regula. All rights reserved.
//

import UIKit
import SafariServices
import DocumentReader

extension DocumentReaderValue {
    open override var debugDescription: String {
        return "\(self.sourceType.stringValue), \(self.value)"
    }
}

class ResultsViewController: UIViewController {
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var overallResultView: UIImageView!
    
    var results: DocumentReaderResults!
    private var resultsGroups: [GroupedAttributes] = []
    private var comparisonGroups: [GroupedAttributes] = []
    private var rfidGroups: [GroupedAttributes] = []
    private var sectionsData: [GroupedAttributes] = []
    
    private let headerHeight: CGFloat = 44
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        
        initResultsData()
        initCompareData()
        
        if ApplicationSettings.shared.isRfidEnabled {
            initRfidData()
        } else {
            segmentedControl.removeSegment(at: 2, animated: false)
        }
        
        sectionsData = resultsGroups
        
        let directBarButton = UIBarButtonItem(title: "Direct", style: .plain, target: self, action: #selector(directButtonAction(_:)))
        navigationItem.rightBarButtonItem = directBarButton
    }
    
    @objc func directButtonAction(_ sender: UIBarButtonItem) {
        showGetValues()
    }
    
    private func showGetValues() {
        let mainStoryboard = UIStoryboard(name: kMainStoryboardId, bundle: nil)
        guard let viewController = mainStoryboard.instantiateViewController(withIdentifier: kGetValuesViewControllerId) as? GetValuesViewController else {
            return
        }
        guard let results = results else { return }
        viewController.results = results
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    @IBAction func segmentedControlAction(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            sectionsData = resultsGroups
        case 1:
            sectionsData = comparisonGroups
        case 2:
            sectionsData = rfidGroups
        default:
            break
        }
        pickerView.reloadAllComponents()
        pickerView.selectRow(0, inComponent: 0, animated: false)
        tableView.reloadData()
    }
    
    private func setupUI() {
        navigationItem.title = "All Results"
        pickerView.dataSource = self
        pickerView.delegate = self
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(UINib.init(nibName: kTextCellId, bundle: nil),
                           forCellReuseIdentifier: kTextCellId)
        tableView.register(UINib.init(nibName: kImageCellId, bundle: nil),
                           forCellReuseIdentifier: kImageCellId)
        
        segmentedControl.selectedSegmentIndex = 0
        
        let statusImageName = results.overallResult == .ok ? "status_ok" : results.overallResult == CheckResult.error ? "status_not_ok" : "status_undefined"
        overallResultView.image = UIImage(named: statusImageName)
    }
    
    private func initResultsData() {
        var attributes: [Attribute] = []
        
        // Process all existing text values
        for field in results.textResult.fields {
            let name = field.fieldName
            for value in field.values {
                let valid = value.validity
                let item = Attribute(name: name, value: value.value, lcid: field.lcid,
                                     valid: valid, source: value.sourceType)
                attributes.append(item)
            }
        }
        
        // Process all existing graphics values
        for field in results.graphicResult.fields {
            let name = field.fieldName + " [\(field.pageIndex)]"
            let image = field.value
            let item = Attribute(name: name, value: "",
                                 source: field.sourceType, image: image)
            attributes.append(item)
        }
        
        // Split all values by types
        let types = Array(Set(attributes.compactMap { $0.source }))
        for type in types {
            let typed = attributes.filter { $0.source == type }
            let group = GroupedAttributes(type: type.stringValue, items: typed)
            resultsGroups.append(group)
        }
        resultsGroups.sort { $0.type < $1.type }
    }
    
    private func initCompareData() {
        // Extract types for comparison
        let values = results.textResult.fields.compactMap { $0.values }.flatMap { $0 }
        let comparisonTypes = Array(Set(values.compactMap { $0.sourceType }))
        
        let typePairs = combinationsFrom(comparisonTypes, taking: 2)
        
        // Extract types for comparison
        typePairs.forEach { pair in
            let groupType = "\(pair[0].stringValue) - \(pair[1].stringValue)"
            let comparisonGroup = GroupedAttributes(type: groupType, items: [],
                                                    comparisonLHS: pair[0], comparisonRHS: pair[1])
            comparisonGroups.append(comparisonGroup)
        }
        
        // Add comparison attributes to appropriate group
        for field in results.textResult.fields {
            let name = field.fieldName
            for value in field.values {
                for (k, v) in value.comparison {
                    guard let keyType = ResultType.init(rawValue: k.intValue) else { continue }
                    guard let result = FieldVerificationResult(rawValue: v.intValue) else { continue }
                    if result == .compareTrue || result == .compareFalse {
                        tryAddValueToGroup(name, value, keyType, result, &comparisonGroups)
                    }
                }
            }
        }
        
        // Remove duplicates in comparison attributes
        for index in comparisonGroups.indices {
            let group = comparisonGroups[index]
            comparisonGroups[index].items = Array(Set(group.items))
        }
        comparisonGroups = comparisonGroups.filter { $0.items.count > 0 }
        
        // Disable "Compare" segment if nothing to compare
        if comparisonGroups.count == 0 {
            segmentedControl.setEnabled(false, forSegmentAt: 1)
        }
    }
    
    // Generate not-repeating pairs from array items.
    private func combinationsFrom<T>(_ elements: [T], taking: Int) -> [[T]] {
        guard elements.count >= taking else { return [] }
        guard elements.count > 0 && taking > 0 else { return [[]] }
        
        if taking == 1 {
            return elements.map {[$0]}
        }
        
        var combinations = [[T]]()
        for (index, element) in elements.enumerated() {
            var reducedElements = elements
            reducedElements.removeFirst(index + 1)
            combinations += combinationsFrom(reducedElements, taking: taking - 1).map { [element] + $0 }
        }
        return combinations
    }
    
    // Helper func for find appropriate comparison group for attribute & append item to it
    private func tryAddValueToGroup(_ name: String, _ value: DocumentReaderValue,
                                    _ key: ResultType, _ result: FieldVerificationResult,
                                    _ groups: inout [GroupedAttributes]) {
        for index in groups.indices {
            let group = groups[index]
            guard let typeLHS = group.comparisonLHS else { return }
            guard let typeRHS = group.comparisonRHS else { return }
            let sourceEquality = (value.sourceType == typeLHS || value.sourceType == typeRHS)
            let targetEquality = (key == typeLHS || key == typeRHS)
            if sourceEquality && targetEquality {
                let item = Attribute(name: name, value: nil, valid: FieldVerificationResult.compareTrue, source: value.sourceType)
                groups[index].items.append(item)
                break
            }
        }
    }
    
    private func initRfidData() {
        defer {
            if rfidGroups.count == 0 {
                segmentedControl.setEnabled(false, forSegmentAt: 2)
            }
        }
        
        guard let applications = results.rfidSessionData?.applications else { return }
        var dataGroup = GroupedAttributes(type: "Data Groups", items: [])
        applications.forEach {
            $0.files.forEach {
                guard $0.readingStatus != RFIDErrorCodes.notAvailable else { return }
                let attribute = Attribute(name: $0.typeName, rfidStatus: $0.pAStatus)
                dataGroup.items.append(attribute)
            }
        }
        if dataGroup.items.count > 0 {
            rfidGroups.append(dataGroup)
        }
        
        guard (results.rfidSessionData?.sessionDataStatus) != nil else { return }
        
        var statusGroup = GroupedAttributes(type: "Data Status", items: [])
        var attribute = Attribute(name: "AA", checkResult: results?.rfidSessionData?.sessionDataStatus.aa)
        statusGroup.items.append(attribute)
        attribute = Attribute(name: "BAC", checkResult: results?.rfidSessionData?.sessionDataStatus.bac)
        statusGroup.items.append(attribute)
        attribute = Attribute(name: "CA", checkResult: results?.rfidSessionData?.sessionDataStatus.ca)
        statusGroup.items.append(attribute)
        attribute = Attribute(name: "PA", checkResult: results?.rfidSessionData?.sessionDataStatus.pa)
        statusGroup.items.append(attribute)
        attribute = Attribute(name: "PACE", checkResult: results?.rfidSessionData?.sessionDataStatus.pace)
        statusGroup.items.append(attribute)
        attribute = Attribute(name: "TA", checkResult: results?.rfidSessionData?.sessionDataStatus.ta)
        statusGroup.items.append(attribute)
        
        if statusGroup.items.count > 0 {
            rfidGroups.append(statusGroup)
        }
    }
    
    private func showHelpPopup(_ tag: Int) {
        guard tag != 0 else {
            return
        }
        
        let mainStoryboard = UIStoryboard(name: kMainStoryboardId, bundle: nil)
        guard let helpViewController = mainStoryboard.instantiateViewController(withIdentifier: kHelpViewControllerId) as? HelpViewController else {
            return
        }
        
        switch tag {
        case 10:
            helpViewController.infoImage = UIImage(named: "info_mrz")
            helpViewController.infoText = kInfoTextMrz
        case 20:
            helpViewController.infoImage = UIImage(named: "info_viz")
            helpViewController.infoText = kInfoTextViz
        case 30:
            helpViewController.infoImage = UIImage(named: "info_barcode")
            helpViewController.infoText = kInfoTextBarcode
        case 40:
            let link = "https://docs.regulaforensics.com/home/faq/security-mechanisms-for-electronic-documents"
            openSafariWith(link)
            return
        default:
            return
        }
        
        self.present(helpViewController, animated: true, completion: nil)
    }
    
    @objc
    private func infoButtonAction(_ sender: UIButton) {
        showHelpPopup(sender.tag)
    }
    
    private func openSafariWith(_ link: String) {
        guard let url = URL(string: link) else { return }
        let controller = SFSafariViewController(url: url)
        self.present(controller, animated: true, completion: nil)
    }
}

extension ResultsViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        sectionsData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        sectionsData[row].type
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        guard sectionsData.count > 0 else { return }
        tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
        guard sectionsData[0].items.count > 0 else { return }
        tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
    }
}

extension ResultsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let selected = pickerView.selectedRow(inComponent: 0)
        guard sectionsData.count > 0 else { return nil }
        return sectionsData[selected].type
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let selected = pickerView.selectedRow(inComponent: 0)
        guard sectionsData.count > 0 else { return 0 }
        return sectionsData[selected].items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let selected = pickerView.selectedRow(inComponent: 0)
        let item = sectionsData[selected].items[indexPath.row]
        
        if (item.image != nil) {
            // Attribute with graphics
            let cell = tableView.dequeueReusableCell(withIdentifier: kImageCellId,
                                                     for: indexPath) as! ImageCell
            cell.titleLabel.text = item.name.uppercased()
            cell.rawImageView.image = item.image
            return cell
        } else if item.value != nil {
            // Attribute with text
            let cell = tableView.dequeueReusableCell(withIdentifier: kTextCellId,
                                                     for: indexPath) as! TextCell
            cell.titleLabel.text = item.name.uppercased()
            cell.valueLabel.text = item.value

            if let lcid = item.lcid {
                cell.lcidLabel.text = lcid.stringValue
            } else {
                cell.lcidLabel.text = ""
            }
            guard let value = item.valid else {
                cell.valueLabel.textColor = .black
                return cell
            }
            if (value == .verified) {
                cell.valueLabel.textColor = .green
            } else if (value == .notVerified) {
                cell.valueLabel.textColor = .red
            } else {
                cell.valueLabel.textColor = .black
            }
            return cell
        } else if item.rfidStatus != nil {
            // Attribute for rfid status
            guard let cell = tableView.dequeueReusableCell(withIdentifier: kRfidStatusCellId) else {
                return UITableViewCell()
            }
            cell.textLabel?.text = item.name.uppercased()
            let imageName = item.rfidStatus == RFIDErrorCodes.failed ? "status_not_ok" : item.rfidStatus == RFIDErrorCodes.noError ? "status_ok" : "status_undefined"
            let imageView = UIImageView(image: UIImage(named: imageName))
            cell.accessoryView = imageView
            return cell
        } else if item.checkResult != nil {
            // Attribute for rfid check
            guard let cell = tableView.dequeueReusableCell(withIdentifier: kRfidStatusCellId) else {
                return UITableViewCell()
            }
            cell.textLabel?.text = item.name.uppercased()
            let imageName = item.checkResult == CheckResult.error ? "status_not_ok" : item.checkResult == CheckResult.ok ? "status_ok" : "status_undefined"
            let imageView = UIImageView(image: UIImage(named: imageName))
            cell.accessoryView = imageView
            return cell
        } else {
            // Attribute for comparison group
            guard let cell = tableView.dequeueReusableCell(withIdentifier: kComparisonCellId) else {
                return UITableViewCell()
            }
            cell.textLabel?.text = item.name.uppercased()
            cell.tintColor = item.equality ? .green : .red
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return headerHeight
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard sectionsData.count > 0 else { return nil }
        
        let selected = pickerView.selectedRow(inComponent: 0)
        let title = sectionsData[selected].type
        var hasButton = title.contains(".mrz") || title.contains(".visual") || title.contains(".barCodes") || title.contains("Data Groups") || title.contains("Data Status")
        // Info buttons only for Results & Rfid tab
        if segmentedControl.selectedSegmentIndex == 1 {
            hasButton = false
        }
        
        let headerView = UIView(frame: CGRect(origin: .zero, size: CGSize(width: 0, height: headerHeight)))
        
        let label = UILabel(frame: CGRect(origin: .zero, size: CGSize(width: 0, height: headerHeight)))
        label.text = title
        label.textColor = .black
        label.textAlignment = .left
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.backgroundColor = UIColor.init(hue: 0, saturation: 0, brightness: 0.9, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        headerView.addSubview(label)
        
        let button = UIButton(type: .infoLight)
        button.backgroundColor = UIColor.init(hue: 0, saturation: 0, brightness: 0.9, alpha: 1)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(infoButtonAction(_:)), for: .touchUpInside)
        headerView.addSubview(button)
        
        NSLayoutConstraint.activate([
            label.rightAnchor.constraint(equalTo: button.leftAnchor),
            label.topAnchor.constraint(equalTo: headerView.topAnchor),
            label.bottomAnchor.constraint(equalTo: headerView.bottomAnchor),
            label.leftAnchor.constraint(equalTo: headerView.leftAnchor),
            button.rightAnchor.constraint(equalTo: headerView.rightAnchor, constant: -8),
            button.widthAnchor.constraint(equalToConstant: hasButton ? headerHeight : 0),
            button.topAnchor.constraint(equalTo: headerView.topAnchor),
            button.bottomAnchor.constraint(equalTo: headerView.bottomAnchor)
        ])
        
        // Button action
        if title.contains(".mrz") {
            button.tag = 10
        } else if title.contains(".visual") {
            button.tag = 20
        } else if title.contains(".barCodes") {
            button.tag = 30
        } else if title.contains("Data Groups") || title.contains("Data Status") {
            button.tag = 40
        }
        
        return headerView
    }
}
