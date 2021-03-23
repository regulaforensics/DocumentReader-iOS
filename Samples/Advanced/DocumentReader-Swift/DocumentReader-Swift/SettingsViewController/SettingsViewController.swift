//
//  SettingsViewController.swift
//  DocumentReader-Swift
//
//  Created by Dmitry Evglevsky on 8.02.21.
//  Copyright © 2021 Regula. All rights reserved.
//

import UIKit
import DocumentReader

class SettingsViewController: UIViewController {
    @IBOutlet var tableView: UITableView!
    private let segmentedControl = UISegmentedControl(items: ["Application", "API"])
    
    private var applicationGroups: [SettingsGroup] = []
    private var apiGroups: [SettingsGroup] = []
    private var sectionsData: [SettingsGroup] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        setupUI()
        initApplicationSettings()
        initAPISettings()
        
        sectionsData = applicationGroups
    }
    
    private func setupUI() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib.init(nibName: kSettingsSwitchCellId, bundle: nil),
                           forCellReuseIdentifier: kSettingsSwitchCellId)
        tableView.register(UINib.init(nibName: kSettingsStepperCellId, bundle: nil),
                           forCellReuseIdentifier: kSettingsStepperCellId)
        tableView.register(UINib.init(nibName: kSettingsActionCellId, bundle: nil),
                           forCellReuseIdentifier: kSettingsActionCellId)
        tableView.tableFooterView = UIView(frame: .zero)
        
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: #selector(segmentedControlAction(_:)), for: .valueChanged)
        navigationItem.titleView = segmentedControl
        
        let resetBarButton = UIBarButtonItem(title: "Reset", style: .plain, target: self, action: #selector(resetButtonAction(_:)))
        navigationItem.rightBarButtonItem = resetBarButton
    }
    
    @objc
    func resetButtonAction(_ sender: UIBarButtonItem) {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            ApplicationSettings.shared.isRfidEnabled = false
            ApplicationSettings.shared.useCustomRfidController = false
        case 1:
            let scenario = DocReader.shared.selectedScenario()
            let defaultProcessParams = ProcessParams()
            DocReader.shared.processParams = defaultProcessParams
            DocReader.shared.processParams.scenario = scenario?.identifier
            let defaultFunctionality = Functionality()
            ApplicationSettings.shared.functionality = defaultFunctionality
            
        default:
            break
        }
        tableView.reloadData()
    }
    
    @objc func segmentedControlAction(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            sectionsData = applicationGroups
        case 1:
            sectionsData = apiGroups
        default:
            break
        }
        tableView.reloadData()
    }
    
    private func initApplicationSettings() {
        // 1. RFID
        let readRfid = SettingsBoolItem(title: "Read RFID") { enabled in
            ApplicationSettings.shared.isRfidEnabled = enabled
        } state: {
            ApplicationSettings.shared.isRfidEnabled
        }
        let customRfid = SettingsBoolItem(title: "Use custom RFID controller") { enabled in
            ApplicationSettings.shared.useCustomRfidController = enabled
        } state: {
            ApplicationSettings.shared.useCustomRfidController
        }
        let rfidGroup = SettingsGroup(title: "RFID", items: [readRfid, customRfid])
        applicationGroups.append(rfidGroup)
    }
    
    private func initAPISettings() {
        // 2. Document processing
        let multipageProcessing = SettingsBoolItem(title: "Multipage processing") { enabled in
            DocReader.shared.processParams.multipageProcessing = enabled
        } state: {
            DocReader.shared.processParams.multipageProcessing
        }
        let doublePageSpread = SettingsBoolItem(title: "Double-page spread processing") { enabled in
            DocReader.shared.processParams.doublePageSpread = enabled
        } state: {
            DocReader.shared.processParams.doublePageSpread
        }
        let manualCrop = SettingsBoolItem(title: "Manual crop") { enabled in
            DocReader.shared.processParams.manualCrop = enabled
        } state: {
            DocReader.shared.processParams.manualCrop
        }
        let docProcessingGroup = SettingsGroup(title: "Document Processing", items: [multipageProcessing, doublePageSpread, manualCrop])
        apiGroups.append(docProcessingGroup)
        
        // 3. Authenticity
        let checkHologram = SettingsBoolItem(title: "Check hologram") { enabled in
            DocReader.shared.processParams.checkHologram = enabled
        } state: {
            DocReader.shared.processParams.checkHologram
        }
        let authenticityGroup = SettingsGroup(title: "Authenticity", items: [checkHologram])
        apiGroups.append(authenticityGroup)
        
        // 4. Timeouts
        let timeoutItem = SettingsIntItem(title: "Timeout", format: "%d sec") { value in
            DocReader.shared.processParams.timeout = TimeInterval(value)
        } state: {
            Int(DocReader.shared.processParams.timeout)
        }
        let timeoutFromFirstDetectItem = SettingsIntItem(title: "Timeout from first detect", format: "%d sec") { value in
            DocReader.shared.processParams.timeoutFromFirstDetect = TimeInterval(value)
        } state: {
            Int(DocReader.shared.processParams.timeoutFromFirstDetect)
        }
        let timeoutFromFirstDocTypeItem = SettingsIntItem(title: "Timeout from first document type", format: "%d sec") { value in
            DocReader.shared.processParams.timeoutFromFirstDocType = TimeInterval(value)
        } state: {
            Int(DocReader.shared.processParams.timeoutFromFirstDocType)
        }
        let timeoutsGroup = SettingsGroup(title: "Timeouts", items: [timeoutItem, timeoutFromFirstDetectItem, timeoutFromFirstDocTypeItem])
        apiGroups.append(timeoutsGroup)
        
        // 5. Display formats
        let dateFormat = SettingsActionItem(title: "Date format") { [weak self] in
            guard let self = self else { return }
            self.showDateFormats() { self.tableView.reloadData() }
        } state: {
            DocReader.shared.processParams.dateFormat
        }
        let measureFormat = SettingsActionItem(title: "Measure format") { [weak self] in
            guard let self = self else { return }
            self.showMeasureFormats() { self.tableView.reloadData() }
        } state: {
            (DocReader.shared.processParams.measureSystem == .metric) ? ".metric" : ".imperial"
        }
        let displayFormatsGroup = SettingsGroup(title: "Display formats", items: [dateFormat, measureFormat])
        apiGroups.append(displayFormatsGroup)
        
        // 6. Logs
        let showLogs = SettingsBoolItem(title: "Show logs") { enabled in
            DocReader.shared.processParams.logs = enabled
        } state: {
            DocReader.shared.processParams.logs
        }
        let saveLogs = SettingsBoolItem(title: "Save logs") { enabled in
            DocReader.shared.processParams.debugSaveLogs = enabled
        } state: {
            DocReader.shared.processParams.debugSaveLogs
        }
        let saveImages = SettingsBoolItem(title: "Save images") { enabled in
            DocReader.shared.processParams.debugSaveImages = enabled
        } state: {
            DocReader.shared.processParams.debugSaveImages
        }
        let saveCroppedImages = SettingsBoolItem(title: "Save cropped images") { enabled in
            DocReader.shared.processParams.debugSaveCroppedImages = enabled
        } state: {
            DocReader.shared.processParams.debugSaveCroppedImages
        }
        let saveRfidSession = SettingsBoolItem(title: "Save RFID session") { enabled in
            DocReader.shared.processParams.debugSaveRFIDSession = enabled
        } state: {
            DocReader.shared.processParams.debugSaveRFIDSession
        }
        let logsGroup = SettingsGroup(title: "Logs", items: [showLogs, saveLogs, saveImages, saveCroppedImages, saveRfidSession])
        apiGroups.append(logsGroup)
        
        // 7. Scenarios
        let captureButtonScenario = SettingsActionItem(title: "Capture button scenario") { [weak self] in
            guard let self = self else { return }
            self.showCaptureButtonScenarioList { self.tableView.reloadData() }
        } state: {
            let current = DocReader.shared.processParams.captureButtonScenario ?? ""
            return current.isEmpty ? "default" : current
        }
        let scenariosGroup = SettingsGroup(title: "Scenarios", items: [captureButtonScenario])
        apiGroups.append(scenariosGroup)
        
        // 8. Barcode types
        let doBarcodes = SettingsActionItem(title: "Do barcodes") { [weak self] in
            guard let self = self else { return }
            self.showBarcodeTypesList() { self.tableView.reloadData() }
        } state: {
            let currentList = DocReader.shared.processParams.barcodeTypes as? [Int] ?? []
            let value = currentList.compactMap { BarcodeType.init(rawValue: $0)?.stringValue }.joined(separator: ", ")
            return value.isEmpty ? "default" : value
        }
        let barcodesParser = SettingsActionItem(title: "Barcode parser type") { [weak self] in
            guard let self = self else { return }
            self.showBarcodeParserTypes() { self.tableView.reloadData() }
        } state: {
            String(DocReader.shared.processParams.barcodeParserType)
        }
        let barcodesGroup = SettingsGroup(title: "Barcode types", items: [doBarcodes, barcodesParser])
        apiGroups.append(barcodesGroup)
        
        // 9. Filters
        let documentIdList = SettingsActionItem(title: "Document ID List") { [weak self] in
            guard let self = self else { return }
            self.showDocumentIdEditor() { self.tableView.reloadData() }
        } state: {
            let currentList = DocReader.shared.processParams.documentIDList as? [Int] ?? []
            let value = currentList.compactMap { String($0) }.joined(separator: ", ")
            return value.isEmpty ? "default" : value
        }
        let fieldTypeFilter = SettingsActionItem(title: "Field type filter") { [weak self] in
            guard let self = self else { return }
            self.showFieldTypeEditor() { self.tableView.reloadData() }
        } state: {
            let currentList = DocReader.shared.processParams.fieldTypesFilter as? [Int] ?? []
            let value = currentList.compactMap { String($0) }.joined(separator: ", ")
            return value.isEmpty ? "default" : value
        }
        let filtersGroup = SettingsGroup(title: "Filters", items: [documentIdList, fieldTypeFilter])
        apiGroups.append(filtersGroup)
        
        // 10. Detection
        let focusingCheck = SettingsBoolItem(title: "Disable focusing check") { enabled in
            DocReader.shared.processParams.disableFocusingCheck = enabled
        } state: { () -> (Bool) in
            DocReader.shared.processParams.disableFocusingCheck
        }
        let perspectiveAngle = SettingsIntItem(title: "Perspective angle") { value in
            DocReader.shared.processParams.perspectiveAngle = value
        } state: {
            DocReader.shared.processParams.perspectiveAngle
        }
        let motionDetection = SettingsBoolItem(title: "Motion detection") { enabled in
            ApplicationSettings.shared.functionality.videoCaptureMotionControl = enabled
        } state: {
            ApplicationSettings.shared.functionality.videoCaptureMotionControl
        }
        let focusingDetection = SettingsBoolItem(title: "Focusing detection") { enabled in
            ApplicationSettings.shared.functionality.skipFocusingFrames = enabled
        } state: {
            ApplicationSettings.shared.functionality.skipFocusingFrames
        }
        let detectionGroup = SettingsGroup(title: "Detection", items: [focusingCheck, perspectiveAngle, motionDetection, focusingDetection])
        apiGroups.append(detectionGroup)
        
        // 11. Output images
        let returnUncroppedImage = SettingsBoolItem(title: "Return uncropped image") { enabled in
            DocReader.shared.processParams.returnUncroppedImage = enabled
        } state: {
            DocReader.shared.processParams.returnUncroppedImage
        }
        let integralImage = SettingsBoolItem(title: "Integral image") { enabled in
            DocReader.shared.processParams.integralImage = enabled
        } state: {
            DocReader.shared.processParams.integralImage
        }
        let minimumDPI = SettingsIntItem(title: "Minimum DPI", format: "%d") { value in
            DocReader.shared.processParams.minDPI = value
        } state: {
            DocReader.shared.processParams.minDPI
        }
        let returnCroppedBarcode = SettingsBoolItem(title: "Return cropped barcode") { enabled in
            DocReader.shared.processParams.returnCroppedBarcode = enabled
        } state: {
            DocReader.shared.processParams.returnCroppedBarcode
        }
        let outputImagesGroup = SettingsGroup(title: "Output images", items: [returnUncroppedImage, integralImage, minimumDPI, returnCroppedBarcode])
        apiGroups.append(outputImagesGroup)
        
        // 12. Custom params
        let customParams = SettingsActionItem(title: "Custom params") { [weak self] in
            guard let self = self else { return }
            self.showCustomParams() { self.tableView.reloadData() }
        } state: {
            return self.getCurrentCustomParams() ?? ""
        }
        let customParamsGroup = SettingsGroup(title: "Custom params", items: [customParams])
        apiGroups.append(customParamsGroup)
        
        // 13. Scanning mode
        let captureMode = SettingsActionItem(title: "Capture mode") { [weak self] in
            guard let self = self else { return }
            self.showCaptureModeList { self.tableView.reloadData() }
        } state: {
            let current = ApplicationSettings.shared.functionality.captureMode
            return current.stringValue
        }
        let scanningModeGroup = SettingsGroup(title: "Scanning mode", items: [captureMode])
        apiGroups.append(scanningModeGroup)
        
        // 14. Video settings
        let adjustZoom = SettingsBoolItem(title: "Adjust zoom level") { enabled in
            ApplicationSettings.shared.functionality.isZoomEnabled = enabled
        } state: {
            ApplicationSettings.shared.functionality.isZoomEnabled
        }
        let zoomFactor = SettingsIntItem(title: "Zoom factor", format: "%d x") { value in
            ApplicationSettings.shared.functionality.zoomFactor = CGFloat(value)
        } state: {
            Int(ApplicationSettings.shared.functionality.zoomFactor)
        }
        let videoSettingsGroup = SettingsGroup(title: "Video settings", items: [adjustZoom, zoomFactor])
        apiGroups.append(videoSettingsGroup)
        
        // 15. Capture device position
        let cameraPosition = SettingsActionItem(title: "Camera position") { [weak self] in
            guard let self = self else { return }
            self.showCameraPositionList { self.tableView.reloadData() }
        } state: {
            let current = ApplicationSettings.shared.functionality.cameraPosition
            return current.stringValue
        }
        let cameraPositionGroup = SettingsGroup(title: "Capture device position", items: [cameraPosition])
        apiGroups.append(cameraPositionGroup)
        
        // 16. Extra info
        let showMetadata = SettingsBoolItem(title: "Show metadata") { enabled in
            ApplicationSettings.shared.functionality.showMetadataInfo = enabled
        } state: {
            ApplicationSettings.shared.functionality.showMetadataInfo
        }
        let extraInfoGroup = SettingsGroup(title: "Extra info", items: [showMetadata])
        apiGroups.append(extraInfoGroup)
        
        // 17. Camera frame
        let cameraFrame = SettingsActionItem(title: "Frame type") { [weak self] in
            guard let self = self else { return }
            self.showCameraFrameList { self.tableView.reloadData() }
        } state: {
            let current = ApplicationSettings.shared.functionality.cameraFrame
            return current.stringValue
        }
        let cameraFrameGroup = SettingsGroup(title: "Camera frame", items: [cameraFrame])
        apiGroups.append(cameraFrameGroup)
        
    }
    
    private func getCurrentCustomParams() -> String? {
        guard let currentParams = DocReader.shared.processParams.customParams as? [String: Any] else {
            return nil
        }
        guard let jsonData = try? JSONSerialization.data(withJSONObject: currentParams, options: []) else {
            return nil
        }
        guard let jsonString = String(data: jsonData, encoding: .utf8) else {
            return nil
        }
        return jsonString
    }
    
    private func showBarcodeTypesList(_ completion: VoidClosure? = nil) {
        let mainStoryboard = UIStoryboard(name: kMainStoryboardId, bundle: nil)
        guard let barcodeListViewController = mainStoryboard.instantiateViewController(withIdentifier: kBarcodeListViewControllerId) as? BarcodeListViewController else {
            return
        }
        barcodeListViewController.allItems = BarcodeType.allCases.compactMap { $0 }
        let selected: [Int] = DocReader.shared.processParams.barcodeTypes?.compactMap { $0 as? Int } ?? []
        barcodeListViewController.selectedItems = selected.compactMap { BarcodeType.init(rawValue: $0) }
        barcodeListViewController.completion = { result in
            guard let barcodes = result else {
                DocReader.shared.processParams.barcodeTypes = nil
                completion?()
                return
            }
            DocReader.shared.processParams.barcodeTypes = barcodes.compactMap { $0.rawValue }
            completion?()
        }
        navigationController?.pushViewController(barcodeListViewController, animated: true)
    }
    
    private func showCustomParams(_ completion: VoidClosure? = nil) {
        let mainStoryboard = UIStoryboard(name: kMainStoryboardId, bundle: nil)
        guard let customParamsViewController = mainStoryboard.instantiateViewController(withIdentifier: kTextViewControllerId) as? TextViewController else {
            return
        }
        
        defer {
            navigationController?.pushViewController(customParamsViewController, animated: true)
        }
        
        customParamsViewController.completion = { result in
            defer {
                completion?()
            }
            guard !result.isEmpty else {
                DocReader.shared.processParams.customParams = nil
                return
            }
            let data = Data(result.utf8)
            guard let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
                DocReader.shared.processParams.customParams = nil
                return
            }
            DocReader.shared.processParams.customParams = json
        }
        
        customParamsViewController.initalValue = getCurrentCustomParams() ?? ""
    }
    
    private func showBarcodeParserTypes(_ completion: VoidClosure? = nil) {
        let mainStoryboard = UIStoryboard(name: kMainStoryboardId, bundle: nil)
        guard let barcodeParserViewController = mainStoryboard.instantiateViewController(withIdentifier: kTextFieldViewControllerId) as? TextFieldViewController else {
            return
        }
        barcodeParserViewController.title = "Barcode parser type"
        barcodeParserViewController.placeholder = "123"
        barcodeParserViewController.isInputForNumbersOnly = true
        barcodeParserViewController.initalValue = String(DocReader.shared.processParams.barcodeParserType)
        barcodeParserViewController.completion = { result in
            DocReader.shared.processParams.barcodeParserType = Int(result) ?? 0
            completion?()
        }
        navigationController?.pushViewController(barcodeParserViewController, animated: true)
    }
    
    private func showDocumentIdEditor(_ completion: VoidClosure? = nil) {
        let mainStoryboard = UIStoryboard(name: kMainStoryboardId, bundle: nil)
        guard let documentIdEditorViewController = mainStoryboard.instantiateViewController(withIdentifier: kTextFieldViewControllerId) as? TextFieldViewController else {
            return
        }
        documentIdEditorViewController.title = "Document ID List"
        documentIdEditorViewController.placeholder = "-274257313, -2004898043"
        let currentList = DocReader.shared.processParams.documentIDList as? [Int] ?? []
        let initialValue = currentList.compactMap { String($0) }.joined(separator: ", ")
        documentIdEditorViewController.initalValue = initialValue
        documentIdEditorViewController.completion = { result in
            let trimmed = result.filter { !$0.isWhitespace }
            let documentsId = trimmed.components(separatedBy: ",").compactMap { Int($0) }
            if documentsId.isEmpty {
                DocReader.shared.processParams.documentIDList = nil
            } else {
                DocReader.shared.processParams.documentIDList = documentsId
            }
            completion?()
        }
        navigationController?.pushViewController(documentIdEditorViewController, animated: true)
    }
    
    private func showFieldTypeEditor(_ completion: VoidClosure? = nil) {
        let mainStoryboard = UIStoryboard(name: kMainStoryboardId, bundle: nil)
        guard let fieldTypeEditorViewController = mainStoryboard.instantiateViewController(withIdentifier: kTextFieldViewControllerId) as? TextFieldViewController else {
            return
        }
        fieldTypeEditorViewController.title = "Field type filter"
        fieldTypeEditorViewController.placeholder = "3, 27"
        let currentList = DocReader.shared.processParams.fieldTypesFilter as? [Int] ?? []
        let initialValue = currentList.compactMap { String($0) }.joined(separator: ", ")
        fieldTypeEditorViewController.initalValue = initialValue
        fieldTypeEditorViewController.completion = { result in
            let trimmed = result.filter { !$0.isWhitespace }
            let fieldTypes = trimmed.components(separatedBy: ",").compactMap { Int($0) }
            if fieldTypes.isEmpty {
                DocReader.shared.processParams.fieldTypesFilter = nil
            } else {
                DocReader.shared.processParams.fieldTypesFilter = fieldTypes
            }
            completion?()
        }
        navigationController?.pushViewController(fieldTypeEditorViewController, animated: true)
    }
    
    private func alertStyleForDevice() -> UIAlertController.Style {
        // On iPad alert will be displayed as action sheet in center of screen
        if (UIDevice.current.userInterfaceIdiom == .pad) {
            return UIAlertController.Style.alert
        } else {
            return UIAlertController.Style.actionSheet
        }
    }
    
    private func showCaptureButtonScenarioList(_ completion: VoidClosure? = nil) {
        let scenarios = DocReader.shared.availableScenarios
        let actionSheet = UIAlertController(title: nil, message: "processParams.captureButtonScenario",
                                            preferredStyle: self.alertStyleForDevice())
        let current = DocReader.shared.processParams.captureButtonScenario ?? ""
        for scenario in scenarios {
            let action = UIAlertAction(title: scenario.identifier, style: .default) { _ in
                DocReader.shared.processParams.captureButtonScenario = scenario.identifier
                completion?()
            }
            if scenario.identifier == current {
                action.setValue(true, forKey: "checked")
            }
            actionSheet.addAction(action)
        }
        actionSheet.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        present(actionSheet, animated: true, completion: nil)
    }
    
    private func showDateFormats(_ completion: VoidClosure? = nil) {
        let masks: [String] = ["dd.MM.yyyy", "dd/mm/yyyy", "mm/dd/yyyy",
                               "dd-mm-yyyy", "mm-dd-yyyy", "dd/mm/yy"]
        
        let actionSheet = UIAlertController(title: nil, message: "processParams.dateFormat",
                                            preferredStyle: self.alertStyleForDevice())
        let currentMask = DocReader.shared.processParams.dateFormat
        for mask in masks {
            let action = UIAlertAction(title: mask, style: .default) { _ in
                DocReader.shared.processParams.dateFormat = mask
                completion?()
            }
            if mask == currentMask {
                action.setValue(true, forKey: "checked")
            }
            actionSheet.addAction(action)
        }
        actionSheet.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        present(actionSheet, animated: true, completion: nil)
    }
    
    private func showMeasureFormats(_ completion: VoidClosure? = nil) {
        let formats: [MeasureSystem] = [.metric, .imperial]
        let actionSheet = UIAlertController(title: nil, message: "processParams.measureSystem",
                                            preferredStyle: self.alertStyleForDevice())
        let current = DocReader.shared.processParams.measureSystem
        for format in formats {
            let action = UIAlertAction(title: format.stringValue, style: .default) { _ in
                DocReader.shared.processParams.measureSystem = format
                completion?()
            }
            if format == current {
                action.setValue(true, forKey: "checked")
            }
            actionSheet.addAction(action)
        }
        actionSheet.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        present(actionSheet, animated: true, completion: nil)
    }
    
    private func showCaptureModeList(_ completion: VoidClosure? = nil) {
        let modes: [CaptureMode] = [.auto, .captureVideo, .captureFrame]
        let actionSheet = UIAlertController(title: nil, message: "functionality.captureMode",
                                            preferredStyle: self.alertStyleForDevice())
        let current = ApplicationSettings.shared.functionality.captureMode
        for mode in modes {
            let action = UIAlertAction(title: mode.stringValue, style: .default) { _ in
                ApplicationSettings.shared.functionality.captureMode = mode
                completion?()
            }
            if mode == current {
                action.setValue(true, forKey: "checked")
            }
            actionSheet.addAction(action)
        }
        actionSheet.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        present(actionSheet, animated: true, completion: nil)
    }
    
    private func showCameraPositionList(_ completion: VoidClosure? = nil) {
        let positions: [AVCaptureDevice.Position] = [.unspecified, .back, .front]
        let actionSheet = UIAlertController(title: nil, message: "functionality.cameraPosition",
                                            preferredStyle: self.alertStyleForDevice())
        let current = ApplicationSettings.shared.functionality.cameraPosition
        for position in positions {
            let action = UIAlertAction(title: position.stringValue, style: .default) { _ in
                ApplicationSettings.shared.functionality.cameraPosition = position
                completion?()
            }
            if position == current {
                action.setValue(true, forKey: "checked")
            }
            actionSheet.addAction(action)
        }
        actionSheet.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        present(actionSheet, animated: true, completion: nil)
    }
    
    private func showCameraFrameList(_ completion: VoidClosure? = nil) {
        let frames: [DocReaderFrame] = [.none, .document, .max, .scenarioDefault]
        let actionSheet = UIAlertController(title: nil, message: "functionality.cameraFrame",
                                            preferredStyle: self.alertStyleForDevice())
        let current = ApplicationSettings.shared.functionality.cameraFrame
        for frame in frames {
            let action = UIAlertAction(title: frame.stringValue, style: .default) { _ in
                ApplicationSettings.shared.functionality.cameraFrame = frame
                completion?()
            }
            if frame == current {
                action.setValue(true, forKey: "checked")
            }
            actionSheet.addAction(action)
        }
        actionSheet.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        present(actionSheet, animated: true, completion: nil)
    }
}

extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        sectionsData[section].title
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        sectionsData.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        sectionsData[section].items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = sectionsData[indexPath.section].items[indexPath.row]
        
        switch item {
        case is SettingsBoolItem:
            if let cell = tableView.dequeueReusableCell(withIdentifier: kSettingsSwitchCellId) as? SettingsSwitchCell {
                cell.item = item as? SettingsBoolItem
                cell.delegate = self
                return cell
            }
        case is SettingsIntItem:
            if let cell = tableView.dequeueReusableCell(withIdentifier: kSettingsStepperCellId) as? SettingsStepperCell {
                cell.item = item as? SettingsIntItem
                cell.delegate = self
                return cell
            }
        case is SettingsActionItem:
            if let cell = tableView.dequeueReusableCell(withIdentifier: kSettingsActionCellId) as? SettingsActionCell {
                cell.item = item as? SettingsActionItem
                cell.delegate = self
                return cell
            }
        default:
            return UITableViewCell()
        }
        
        return UITableViewCell()
    }
}

extension SettingsViewController: SettingsSwitchCellDelegate {
    func stateChangedFor(_ item: SettingsBoolItem?, _ isOn: Bool) {
        item?.action(isOn)
    }
}

extension SettingsViewController: SettingsStepperCellDelegate {
    func valueChangedFor(_ item: SettingsIntItem?, _ value: Int) {
        item?.action(value)
    }
}

extension SettingsViewController: SettingsActionCellDelegate {
    func actionFor(_ item: SettingsActionItem?) {
        item?.action()
    }
}
