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

    lazy var loaderView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .gray)
        view.hidesWhenStopped = true
        return view
    }()
    
    private var applicationGroups: [SettingsGroup] = []
    private var apiGroups: [SettingsGroup] = []
    private var sectionsData: [SettingsGroup] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        initApplicationSettings()
        initAPISettings()
        
        sectionsData = applicationGroups

        view.addSubview(loaderView)
        loaderView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            loaderView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loaderView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
    
    private func setupUI() {
        tableView.dataSource = self
        tableView.delegate = self

        tableView.register(UINib(nibName: SettingsSwitchCell.className, bundle: nil),
                           forCellReuseIdentifier: SettingsSwitchCell.className)
        tableView.register(UINib(nibName: SettingsStepperCell.className, bundle: nil),
                           forCellReuseIdentifier: SettingsStepperCell.className)
        tableView.register(UINib(nibName: SettingsActionCell.className, bundle: nil),
                           forCellReuseIdentifier: SettingsActionCell.className)
        tableView.tableFooterView = UIView(frame: .zero)
        
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: #selector(onSegmentControlValueChange(_:)), for: .valueChanged)
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

            initApplicationSettings()
            sectionsData = applicationGroups
        case 1:
            let scenario = DocReader.shared.selectedScenario()
            let defaultProcessParams = ProcessParams()
            DocReader.shared.processParams = defaultProcessParams
            DocReader.shared.processParams.scenario = scenario?.identifier
            let defaultFunctionality = Functionality()
            ApplicationSettings.shared.functionality = defaultFunctionality
            DocReader.shared.functionality = defaultFunctionality

            initAPISettings()
            sectionsData = apiGroups
        default:
            break
        }
        tableView.reloadData()
    }
    
    @objc func onSegmentControlValueChange(_ sender: UISegmentedControl) {
        switch segmentedControl.selectedSegmentIndex {
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
        self.applicationGroups.removeAll()

        let settings = ApplicationSettings.shared

        // 1. RFID
        let readRfid = SettingsBoolItem(title: "Read RFID", object: settings, keypath: \.isRfidEnabled)
        let customRfid = SettingsBoolItem(title: "Use custom RFID controller", object: settings, keypath: \.useCustomRfidController)
        let rfidGroup = SettingsGroup(title: "RFID", items: [readRfid, customRfid])
        applicationGroups.append(rfidGroup)
        
        // 2. Data encryption
        let dataEncryption = SettingsBoolItem(title: "Data encryption", object: settings, keypath: \.isDataEncryptionEnabled)
        let securityGroup = SettingsGroup(title: "Security", items: [dataEncryption])
        applicationGroups.append(securityGroup)
    }
    
    private func initAPISettings() {
        self.apiGroups.removeAll()

        let functionality = DocReader.shared.functionality
        let params = DocReader.shared.processParams

        // 1. Buttons
        let torchButton = SettingsBoolItem(title: "Torch button", object: functionality, keypath: \.showTorchButton)
        let cameraSwitchButton = SettingsBoolItem(title: "Camera Switch button", object: functionality, keypath: \.showCameraSwitchButton)
        let captureButton = SettingsBoolItem(title: "Capture button", object: functionality, keypath: \.showCaptureButton)
        let delayFromStart = SettingsIntItem(title: "Capture button delay (from start)", format: "%d sec") { value in
            DocReader.shared.functionality.showCaptureButtonDelayFromStart = TimeInterval(value)
        } getter: {
            Int(DocReader.shared.functionality.showCaptureButtonDelayFromStart)
        }
        let delayFromDetect = SettingsIntItem(title: "Capture button delay (from detect)", format: "%d sec") { value in
            DocReader.shared.functionality.showCaptureButtonDelayFromDetect = TimeInterval(value)
        } getter: {
            Int(DocReader.shared.functionality.showCaptureButtonDelayFromDetect)
        }
        let changeFrameButton = SettingsBoolItem(title: "Change Frame button", object: functionality, keypath: \.showChangeFrameButton)
        let closeButton = SettingsBoolItem(title: "Close button", object: functionality, keypath: \.showCloseButton)
        let buttonsGroup = SettingsGroup(title: "Buttons", items: [torchButton, cameraSwitchButton, captureButton, delayFromStart, delayFromDetect, changeFrameButton, closeButton])
        apiGroups.append(buttonsGroup)
        
        // 2. Document processing
        let multipageProcessing = SettingsOptionalBoolItem(title: "Multipage processing", object: params, keypath: \.multipageProcessing)
        let doublePageSpread = SettingsOptionalBoolItem(title: "Double-page spread processing", object: params, keypath: \.doublePageSpread)
        let manualCrop = SettingsOptionalBoolItem(title: "Manual crop", object: params, keypath: \.manualCrop)
        let docProcessingGroup = SettingsGroup(title: "Document Processing", items: [multipageProcessing, doublePageSpread, manualCrop])
        apiGroups.append(docProcessingGroup)
        
        // 3. Authenticity

        let checkHologram = SettingsOptionalBoolItem(title: "Check hologram", object: params, keypath: \.checkHologram)
        let authenticityGroup = SettingsGroup(title: "Authenticity", items: [checkHologram])
        apiGroups.append(authenticityGroup)
        
        // 4. Timeouts
        let timeoutItem = SettingsOptionalIntItem(title: "Timeout", format: "%d sec", object: params, keypath: \.timeout)
        let timeoutFromFirstDetectItem = SettingsOptionalIntItem(title: "Timeout from first detect", format: "%d sec", object: params, keypath: \.timeoutFromFirstDetect)
        let timeoutFromFirstDocTypeItem = SettingsOptionalIntItem(title: "Timeout from first document type", format: "%d sec", object: params, keypath: \.timeoutFromFirstDocType)
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
        let showLogs = SettingsOptionalBoolItem(title: "Show logs", object: params, keypath: \.logs)
        let saveLogs = SettingsOptionalBoolItem(title: "Save logs", object: params, keypath: \.debugSaveLogs)
        let saveImages = SettingsOptionalBoolItem(title: "Save images", object: params, keypath: \.debugSaveImages)
        let saveCroppedImages = SettingsOptionalBoolItem(title: "Save cropped images", object: params, keypath: \.debugSaveCroppedImages)
        let saveRfidSession = SettingsOptionalBoolItem(title: "Save RFID session", object: params, keypath: \.debugSaveRFIDSession)

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
        let barcodesParser = SettingsOptionalIntItem(title: "Barcode parser type", object: params, keypath: \.barcodeParserType)
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
            self.showIntegerArrayEditor(title: "Field type filter", inputArray: DocReader.shared.processParams.fieldTypesFilter as? [Int]) { output in
                DocReader.shared.processParams.fieldTypesFilter = output
                self.tableView.reloadData()
            }
        } state: {
            let currentList = DocReader.shared.processParams.fieldTypesFilter as? [Int] ?? []
            let value = currentList.compactMap { String($0) }.joined(separator: ", ")
            return value.isEmpty ? "default" : value
        }
        let filtersGroup = SettingsGroup(title: "Filters", items: [documentIdList, fieldTypeFilter])
        apiGroups.append(filtersGroup)
        
        // 10. Detection
        let focusingCheck = SettingsOptionalBoolItem(title: "Disable focusing check", object: params, keypath: \.disableFocusingCheck)
        let perspectiveAngle = SettingsOptionalIntItem(title: "Perspective angle", object: params, keypath: \.perspectiveAngle)
        let motionDetection = SettingsBoolItem(title: "Motion detection") { enabled in
            ApplicationSettings.shared.functionality.videoCaptureMotionControl = enabled
        } getter: {
            ApplicationSettings.shared.functionality.videoCaptureMotionControl
        }
        let focusingDetection = SettingsBoolItem(title: "Focusing detection") { enabled in
            ApplicationSettings.shared.functionality.skipFocusingFrames = enabled
        } getter: {
            ApplicationSettings.shared.functionality.skipFocusingFrames
        }
        let detectionGroup = SettingsGroup(title: "Detection", items: [focusingCheck, perspectiveAngle, motionDetection, focusingDetection])
        apiGroups.append(detectionGroup)

        // 11. Output images
        let returnUncroppedImage = SettingsOptionalBoolItem(title: "Return uncropped image", object: params, keypath: \.returnUncroppedImage)
        let integralImage = SettingsOptionalBoolItem(title: "Integral image", object: params, keypath: \.integralImage)
        let minimumDPI = SettingsOptionalIntItem(title: "Minimum DPI", format: "%d", object: params, keypath: \.minDPI)
        let returnCroppedBarcode = SettingsOptionalBoolItem(title: "Return cropped barcode", object: params, keypath: \.returnCroppedBarcode)
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
        } getter: {
            ApplicationSettings.shared.functionality.isZoomEnabled
        }
        let zoomFactor = SettingsIntItem(title: "Zoom factor", format: "%d x") { value in
            ApplicationSettings.shared.functionality.zoomFactor = CGFloat(value)
        } getter: {
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
        } getter: {
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

        // 18. Recognition params
        let resultTypeOutput = SettingsActionItem(title: "Result type output") { [weak self] in
            guard let self = self else { return }
            self.showIntegerArrayEditor(title: "Result type output", inputArray: DocReader.shared.processParams.resultTypeOutput as? [Int]) { output in
                DocReader.shared.processParams.resultTypeOutput = output
                self.tableView.reloadData()
            }
        } state: {
            let currentList = DocReader.shared.processParams.resultTypeOutput ?? []
            let value = currentList.compactMap { $0.stringValue }.joined(separator: ", ")
            return value.isEmpty ? "nil" : value
        }
        let generateDoublePageSpreadImage = SettingsOptionalBoolItem(title: "Generate Double Page Spread Image", object: params, keypath: \.generateDoublePageSpreadImage)
        let imageDpiOutMax = SettingsOptionalIntItem(title: "Image Dpi Out Max", object: params, keypath: \.imageDpiOutMax)
        let alreadyCropped = SettingsOptionalBoolItem(title: "Already Cropped", object: params, keypath: \.alreadyCropped)
        let forceDocID = SettingsOptionalIntItem(title: "Force Doc ID", object: params, keypath: \.forceDocID)
        let matchTextFieldMask = SettingsOptionalBoolItem(title: "Match Text Field Mask", object: params, keypath: \.matchTextFieldMask)
        let fastDocDetect = SettingsOptionalBoolItem(title: "Fast Doc Detect", object: params, keypath: \.fastDocDetect)
        let updateOCRValidityByGlare = SettingsOptionalBoolItem(title: "Update OCR Validity By Glare", object: params, keypath: \.updateOCRValidityByGlare)
        let noGraphics = SettingsOptionalBoolItem(title: "No Graphics", object: params, keypath: \.noGraphics)

        let documentAreaMin = SettingsActionItem(title: "Document Area Min") { [weak self] in
            guard let self = self else { return }
            self.showFloatValueController(title: "Document Area Min", initalValue: String(DocReader.shared.processParams.documentAreaMin?.stringValue ?? ""))
            { value in
                DocReader.shared.processParams.documentAreaMin = value.map { NSNumber(value: $0) }
                self.tableView.reloadData()
            }
        } state: {
            String(DocReader.shared.processParams.documentAreaMin?.stringValue ?? "")
        }
        let forceDocFormat = SettingsActionItem(title: "Force Doc Format") { [weak self] in
            guard let self = self else { return }
            let currentValue = params.forceDocFormat.map { $0.intValue }.flatMap { DocFormat(rawValue: $0)?.description } ?? "nil"
            let options: [String] = DocFormat.allCases.map { $0.description } + ["nil"]
            self.showOptionsPicker(title: "Force Doc Format", current: [currentValue], options: options) { (result) in
                let param = DocFormat(result).map { NSNumber(value: $0.rawValue) }
                DocReader.shared.processParams.forceDocFormat = param
                self.tableView.reloadData()
            }
        } state: {
            let currentValue = params.forceDocFormat.map { $0.intValue }.flatMap { DocFormat(rawValue: $0)?.description } ?? "nil"
            return currentValue
        }
        let multiDocOnImage = SettingsOptionalBoolItem(title: "Multi Doc On Image", object: params, keypath: \.multiDocOnImage)
        let shiftExpiryDate = SettingsOptionalIntItem(title: "Shift Expiry Date", object: params, keypath: \.shiftExpiryDate)
        let minimalHolderAge = SettingsOptionalIntItem(title: "Minimal Holder Age", object: params, keypath: \.minimalHolderAge)

        let mrzFormatsFilter = SettingsActionItem(title: "MRZ Formats Filter") { [weak self] in
            guard let self = self else { return }
            let currentValue = params.mrzFormatsFilter?.map { $0.intValue }.compactMap { MRZFormat(rawValue: $0)?.description } ?? []
            let options: [String] = MRZFormat.allCases.map { $0.description }
            self.showOptionsPicker(title: "MRZ Formats Filter", current: currentValue, options: options) { (result) in
                guard let param = MRZFormat(result).map({ NSNumber(value: $0.rawValue) }) else { return }

                var filters = params.mrzFormatsFilter ?? []
                if let paramIndex = filters.firstIndex(of: param) {
                    filters.remove(at: paramIndex)
                } else {
                    filters.append(param)
                }

                DocReader.shared.processParams.mrzFormatsFilter = filters
                self.tableView.reloadData()
            }
        } state: {
            let currentList = DocReader.shared.processParams.mrzFormatsFilter ?? []
            let value = currentList.compactMap { MRZFormat(rawValue: $0.intValue)?.description }.joined(separator: ", ")
            return value.isEmpty ? "nil" : value
        }

        let forceReadMrzBeforeLocate = SettingsOptionalBoolItem(title: "Force Read Mrz Before Locate", object: params, keypath: \.forceReadMrzBeforeLocate)


        let recognitionParamsGroup = SettingsGroup(title: "Recognition params", items: [resultTypeOutput, generateDoublePageSpreadImage, imageDpiOutMax, alreadyCropped, forceDocID, matchTextFieldMask, fastDocDetect, updateOCRValidityByGlare, noGraphics, documentAreaMin, forceDocFormat, multiDocOnImage, shiftExpiryDate, minimalHolderAge, mrzFormatsFilter, forceReadMrzBeforeLocate])
        apiGroups.append(recognitionParamsGroup)

        // 19. Image QA
        let dpiThreshold = SettingsOptionalIntItem(title: "DPI Treshold", object: params.imageQA, keypath: \.dpiThreshold)
        let angleThreshold = SettingsOptionalIntItem(title: "Angle Threshold", object: params.imageQA, keypath: \.angleThreshold)
        let focusCheck = SettingsOptionalBoolItem(title: "Focus Check", object: params.imageQA, keypath: \.focusCheck)
        let glaresCheck = SettingsOptionalBoolItem(title: "Glares Check", object: params.imageQA, keypath: \.glaresCheck)
        let colornessCheck = SettingsOptionalBoolItem(title: "Colorness Check", object: params.imageQA, keypath: \.colornessCheck)
        let moireCheck = SettingsOptionalBoolItem(title: "Moire Check", object: params.imageQA, keypath: \.moireCheck)
        let imageQAGroup = SettingsGroup(title: "Image QA", items: [dpiThreshold, angleThreshold, focusCheck, glaresCheck, colornessCheck, moireCheck])
        apiGroups.append(imageQAGroup)

        // Misc
        let initAPI = SettingsActionItem(
            title: "Press to init the API",
            action: { [weak self] in
                guard let self = self else { return }
                self.view.isUserInteractionEnabled = false
                self.loaderView.startAnimating()
                DocumentReaderService.shared.initializeDatabaseAndAPI(progress: { state in
                    switch state {
                    case .downloadingDatabase: break
                    case .initializingAPI: break
                    case .completed:
                        self.view.isUserInteractionEnabled = true
                        self.loaderView.stopAnimating()
                        let doneAlert = UIAlertController(title: nil, message: "Initialized",
                                                            preferredStyle: .alert)
                        doneAlert.addAction(UIAlertAction.init(title: "OK", style: .cancel, handler: nil))
                        self.present(doneAlert, animated: true, completion: nil)
                    case .error(let string):
                        self.view.isUserInteractionEnabled = true
                        self.loaderView.stopAnimating()
                        let errorAlert = UIAlertController(title: nil, message: string,
                                                            preferredStyle: .alert)
                        errorAlert.addAction(UIAlertAction.init(title: "OK", style: .cancel, handler: nil))
                        self.present(errorAlert, animated: true, completion: nil)
                    }
                })
            },
            state: { return "" }
        )
        let deinitAPI = SettingsActionItem(
            title: "Press to deinit the API",
            action: {
                DocumentReaderService.shared.deinitializeAPI()
                let doneAlert = UIAlertController(title: nil, message: "Deinitialized",
                                                    preferredStyle: .alert)
                doneAlert.addAction(UIAlertAction.init(title: "OK", style: .cancel, handler: nil))
                self.present(doneAlert, animated: true, completion: nil)
            },
            state: { return "" }
        )
        let miscGroup =  SettingsGroup(title: "Miscellaneous", items: [initAPI, deinitAPI])

        apiGroups.append(miscGroup)
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
            DocReader.shared.processParams.barcodeTypes = barcodes.compactMap { NSNumber(value: $0.rawValue) }
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
            let documentsId = trimmed.components(separatedBy: ",")
                .compactMap { Int($0).map { NSNumber(value: $0) } }

            if documentsId.isEmpty {
                DocReader.shared.processParams.documentIDList = nil
            } else {
                DocReader.shared.processParams.documentIDList = documentsId
            }
            completion?()
        }
        navigationController?.pushViewController(documentIdEditorViewController, animated: true)
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

    private func showOptionsPicker(title: String, current: [String], options: [String], completion: @escaping (String) -> Void) {
        let actionSheet = UIAlertController(title: nil, message: title, preferredStyle: self.alertStyleForDevice())

        for option in options {
            let action = UIAlertAction(title: option, style: .default) { _ in
                completion(option)
            }

            for selected in current where selected == option {
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

    private func showOptionalBoolAlertController(parameter: NSNumber?, completion: ((Bool?) -> Void)? = nil) {
        let positions: [Bool?] = [true, false, nil]
        let actionSheet = UIAlertController(title: nil, message: "Bool?",
                                            preferredStyle: self.alertStyleForDevice())
        for position in positions {
            let action = UIAlertAction(title: position?.description ?? "nil", style: .default) { _ in
                completion?(position)
            }
            if position == parameter?.boolValue {
                action.setValue(true, forKey: "checked")
            }
            actionSheet.addAction(action)
        }
        actionSheet.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        present(actionSheet, animated: true, completion: nil)
    }

    private func showOptionalIntAlertController(parameter: Int?, completion: @escaping (Int?) -> Void) {
        let alert = UIAlertController(title: nil, message: "Int?", preferredStyle: .alert)
        alert.addTextField()

        let currentValue = parameter.map { String($0) } ?? ""
        let textField = alert.textFields?.first
        textField?.text = currentValue

        let action = UIAlertAction(title: "Ok", style: .default) { _ in
            let result = textField?.text.flatMap { Int($0) }
            completion(result)
        }

        alert.addAction(action)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }

    private func showFloatValueController(title: String, placeholder: String = "0.75", initalValue: String, _ completion: OptionalFloatClosure? = nil) {
        let mainStoryboard = UIStoryboard(name: kMainStoryboardId, bundle: nil)
        guard let viewController = mainStoryboard.instantiateViewController(withIdentifier: kTextFieldViewControllerId) as? TextFieldViewController else {
            return
        }
        viewController.title = title
        viewController.placeholder = placeholder
        viewController.initalValue = initalValue
        viewController.completion = { result in
            completion?(Float(result))
        }
        navigationController?.pushViewController(viewController, animated: true)
    }

    private func showIntegerArrayEditor(title: String, placeholder:String = "3, 27", inputArray:[Int]?, _ completion: NSNumberArrayClosure? = nil) {
        let mainStoryboard = UIStoryboard(name: kMainStoryboardId, bundle: nil)
        guard let viewController = mainStoryboard.instantiateViewController(withIdentifier: kTextFieldViewControllerId) as? TextFieldViewController else {
            return
        }
        viewController.title = title
        viewController.placeholder = placeholder
        let currentList = inputArray ?? []
        let initialValue = currentList.compactMap { String($0) }.joined(separator: ", ")
        viewController.initalValue = initialValue
        viewController.completion = { result in
            let trimmed = result.filter { !$0.isWhitespace }
            if trimmed.isEmpty {
                completion?(nil)
            } else {
                let fieldTypes = trimmed.components(separatedBy: ",").compactMap { NSNumber(value:Int($0) ?? 0) }
                completion?(fieldTypes.isEmpty ? nil : fieldTypes)
            }
        }
        navigationController?.pushViewController(viewController, animated: true)
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
        case let item as SettingsBoolItem:
            if let cell = tableView.dequeueReusableCell(withIdentifier: SettingsSwitchCell.className) as? SettingsSwitchCell {
                cell.item = item
                cell.delegate = self
                return cell
            }
        case let item as SettingsOptionalBoolItem:
            if let cell = tableView.dequeueReusableCell(withIdentifier: SettingsActionCell.className) as? SettingsActionCell {
                let currentValue: String = item.getter().map { String($0) } ?? "nil"
                cell.configure(title: item.title, value: currentValue)
                cell.onPressAction = { [weak self, weak item] cell in
                    guard let self = self, let item = item else { return }
                    let parameter = item.getter().map { NSNumber(value: $0) }
                    self.showOptionalBoolAlertController(parameter: parameter, completion: { (result: Bool?) in
                        item.setter(result)
                        self.tableView.reloadRows(at: [indexPath], with: .automatic)
                    })
                }
                return cell
            }

        case let item as SettingsOptionalIntItem:
            if let cell = tableView.dequeueReusableCell(withIdentifier: SettingsActionCell.className) as? SettingsActionCell {
                let currentValue: String
                if let value = item.getter() {
                    currentValue = String(format: item.format, arguments: [value])
                } else {
                    currentValue = "default"
                }

                cell.configure(title: item.title, value: currentValue)
                cell.onPressAction = { [weak self, weak item] cell in
                    guard let self = self, let item = item else { return }
                    let currentValue = item.getter()
                    self.showOptionalIntAlertController(parameter: currentValue, completion: { (result: Int?) in
                        item.setter(result)
                        self.tableView.reloadRows(at: [indexPath], with: .automatic)
                    })
                }
                return cell
            }
        case let item as SettingsIntItem:
            if let cell = tableView.dequeueReusableCell(withIdentifier: SettingsStepperCell.className) as? SettingsStepperCell {
                cell.item = item
                cell.delegate = self
                return cell
            }
        case let item as SettingsActionItem:
            if let cell = tableView.dequeueReusableCell(withIdentifier: SettingsActionCell.className) as? SettingsActionCell {
                cell.configure(title: item.title, value: item.state())
                cell.onPressAction = { [weak item] cell in
                    item?.action()
                }
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
        item?.setter(isOn)
    }
}

extension SettingsViewController: SettingsStepperCellDelegate {
    func valueChangedFor(_ item: SettingsIntItem?, _ value: Int) {
        item?.setter(value)
    }
}
