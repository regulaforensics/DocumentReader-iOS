//
//  MainViewController.swift
//  DocumentReader-Swift
//
//  Created by Dmitry Evglevsky on 2/3/21.
//  Copyright © 2021 Regula. All rights reserved.
//

import UIKit
import DocumentReader
import Photos
import SafariServices

class MainViewController: UIViewController {
    @IBOutlet weak var settingsBarButton: UIBarButtonItem!
    @IBOutlet weak var helpBarButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loaderContainer: UIView!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var scenarioPicker: UIPickerView!
    
    var imagePicker = UIImagePickerController()
    private var sectionsData: [CustomizationSection] = []
    private var pickerImages: [UIImage] = []
    
    var isCustomUILayerEnabled: Bool = false
    lazy var animationTimer = Timer.scheduledTimer(timeInterval: 1.0/60, target: self, selector: #selector(fireTimer), userInfo: nil, repeats: true)
    
    // JSON string for custom UI layer
    let customLayerJsonString =
    """
    {
    "objects": [
    {
    "label": {
      "text": "Searching document...",
      "fontStyle": "normal",
      "fontColor": "#FF444444",
      "fontSize": 24,
      "alignment": "center",
      "background": "#BBDDDDDD",
      "borderRadius": 10,
      "padding": {
        "start": 20,
        "end": 20,
        "top": 20,
        "bottom": 20
      },
      "position": {
        "v": 1.0
      },
      "margin": {
        "start": 24,
        "end": 24
      }
    }
    }]
    }
    """
    
    override func viewDidLoad() {
        super.viewDidLoad()

        DocumentReaderService.shared.initializeDatabaseAndAPI(progress: { [weak self] state in
            guard let self = self else { return }
            switch state {
            case .downloadingDatabase(progress: let progress):
                let progressValue = String(format: "%.1f", progress * 100)
                self.statusLabel.text = "Downloading database: \(progressValue)%"
            case .initializingAPI:
                self.statusLabel.text = "Initializing..."
                self.activityIndicator.stopAnimating()
            case .completed:
                self.enableUserInterfaceOnSuccess()
                self.initSections()
                self.tableView.reloadData()
            case .error(let text):
                self.statusLabel.text = text
                self.enableUserInterfaceOnSuccess()
                self.initSectionsWithoutLicence()
                self.tableView.reloadData()
                print(text)
            }
        })

        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView(frame: .zero)
        
        scenarioPicker.dataSource = self
        scenarioPicker.delegate = self
    }
    
    @IBAction func settingsAction(_ sender: UIBarButtonItem) {
        showSettingsScreen()
    }
    
    @IBAction func helpAcion(_ sender: UIBarButtonItem) {
        showHelpPopup()
    }
    
    // MARK: - Private methods

    lazy var onlineProcessing: CustomizationItem = {
        let item = CustomizationItem("Online Processing") { [weak self] in
            guard let self = self else { return }
            let container = UINavigationController(rootViewController: OnlineProcessingViewController())
            container.modalPresentationStyle = .fullScreen
            self.present(container, animated: true, completion: nil)
        }
        return item
    }()

    private func initSectionsWithoutLicence() {
        let childModeSection = CustomizationSection("Custom", [onlineProcessing])
        sectionsData.append(childModeSection)
    }
    
    private func initSections() {
        // 1. Default
        let defaultScanner = CustomizationItem("Default (showScanner)") {
            DocReader.shared.functionality = ApplicationSettings.shared.functionality
        }
        defaultScanner.resetFunctionality = false
        let stillImage = CustomizationItem("Gallery (recognizeImages)")
        stillImage.actionType = .gallery
        let defaultSection = CustomizationSection("Default", [defaultScanner, stillImage])
        sectionsData.append(defaultSection)
        
        // 2. Custom modes
        let childModeScanner = CustomizationItem("Child mode") { [weak self] in
            guard let self = self else { return }
            self.showAsChildViewController()
        }
        childModeScanner.actionType = .custom
        let manualMultipageMode = CustomizationItem("Manual multipage mode") { [weak self] in
            guard let self = self else { return }
            // Set default copy of functionality
            DocReader.shared.functionality = ApplicationSettings.shared.functionality
            // Manual multipage mode
            DocReader.shared.functionality.manualMultipageMode = true
            DocReader.shared.startNewSession()
            self.showScannerForManualMultipage()
        }
        manualMultipageMode.resetFunctionality = false
        manualMultipageMode.actionType = .custom
        let customUILayerModeStatic = CustomizationItem("Custom UI Layer JSON") { [weak self] in
            guard let self = self else { return }
            self.setupCustomUIFromFile()
        }
        let customUILayerModeAnimated = CustomizationItem("Custom UI Layer JSON Animated") { [weak self] in
            guard let self = self else { return }
            self.isCustomUILayerEnabled = true
            self.animationTimer.fire()
        }
        let customModedSection = CustomizationSection("Custom", [childModeScanner, manualMultipageMode, onlineProcessing, customUILayerModeStatic, customUILayerModeAnimated])
        sectionsData.append(customModedSection)
        
        // 3. Custom camera frame
        let customBorderWidth = CustomizationItem("Custom border width") { () -> (Void) in
            DocReader.shared.customization.cameraFrameBorderWidth = 10
        }
        let customBorderColor = CustomizationItem("Custom border color") { () -> (Void) in
            DocReader.shared.customization.cameraFrameDefaultColor = .red
            DocReader.shared.customization.cameraFrameActiveColor = .purple
        }
        let customShape = CustomizationItem("Custom shape") { () -> (Void) in
            DocReader.shared.customization.cameraFrameShapeType = .corners
            DocReader.shared.customization.cameraFrameLineLength = 40
            DocReader.shared.customization.cameraFrameCornerRadius = 10
            DocReader.shared.customization.cameraFrameLineCap = .round
        }
        let customOffset = CustomizationItem("Custom offset") { () -> (Void) in
            DocReader.shared.customization.cameraFrameOffsetWidth = 50
        }
        let customAspectRatio = CustomizationItem("Custom aspect ratio") { () -> (Void) in
            DocReader.shared.customization.cameraFramePortraitAspectRatio = 1.0
            DocReader.shared.customization.cameraFrameLandscapeAspectRatio = 1.0
        }
        let customFramePosition = CustomizationItem("Custom position") { () -> (Void) in
            DocReader.shared.customization.cameraFrameVerticalPositionMultiplier = 0.5
        }
        
        let customCameraFrameItems = [customBorderWidth, customBorderColor, customShape, customOffset, customAspectRatio, customFramePosition]
        let customCameraFrameSection = CustomizationSection("Custom camera frame", customCameraFrameItems)
        sectionsData.append(customCameraFrameSection)
        
        // 4. Custom toolbar
        let customTorchButton = CustomizationItem("Custom torch button") { () -> (Void) in
            DocReader.shared.functionality.showTorchButton = true
            DocReader.shared.customization.torchButtonOnImage = UIImage(named: "light-on")
            DocReader.shared.customization.torchButtonOffImage = UIImage(named: "light-off")
        }
        let customCameraSwitch = CustomizationItem("Custom camera switch button") { () -> (Void) in
            DocReader.shared.functionality.showCameraSwitchButton = true
            DocReader.shared.customization.cameraSwitchButtonImage = UIImage(named: "camera")
        }
        let customCaptureButton = CustomizationItem("Custom capture button") { () -> (Void) in
            DocReader.shared.functionality.showCaptureButton = true
            DocReader.shared.functionality.showCaptureButtonDelayFromStart = 0
            DocReader.shared.functionality.showCaptureButtonDelayFromDetect = 0
            DocReader.shared.customization.captureButtonImage = UIImage(named: "palette")
        }
        let customChangeFrameButton = CustomizationItem("Custom change frame button") { () -> (Void) in
            DocReader.shared.functionality.showChangeFrameButton = true
            DocReader.shared.customization.changeFrameButtonExpandImage = UIImage(named: "expand")
            DocReader.shared.customization.changeFrameButtonCollapseImage = UIImage(named: "collapse")
        }
        let customCloseButton = CustomizationItem("Custom close button") { () -> (Void) in
            DocReader.shared.functionality.showCloseButton = true
            DocReader.shared.customization.closeButtonImage = UIImage(named: "close")
        }
        let customSizeOfToolbar = CustomizationItem("Custom size of the toolbar") { () -> (Void) in
            DocReader.shared.customization.toolbarSize = 120
            DocReader.shared.customization.torchButtonOnImage = UIImage(named: "light-on")
            DocReader.shared.customization.torchButtonOffImage = UIImage(named: "light-off")
            DocReader.shared.customization.closeButtonImage = UIImage(named: "big_close")
            //DocReader.shared.customization.
        }
        
        let customToolbarItems = [customTorchButton, customCameraSwitch, customCaptureButton, customChangeFrameButton, customCloseButton, customSizeOfToolbar]
        let customToolbarSection = CustomizationSection("Custom toolbar", customToolbarItems)
        sectionsData.append(customToolbarSection)
        
        // 5. Custom status messages
        let customText = CustomizationItem("Custom text") { () -> (Void) in
            DocReader.shared.customization.showStatusMessages = true
            DocReader.shared.customization.status = "Custom status"
        }
        let customTextFont = CustomizationItem("Custom text font") { () -> (Void) in
            DocReader.shared.customization.showStatusMessages = true
            DocReader.shared.customization.statusTextFont = UIFont.systemFont(ofSize: 24, weight: .semibold)
        }
        let customTextColor = CustomizationItem("Custom text color") { () -> (Void) in
            DocReader.shared.customization.showStatusMessages = true
            DocReader.shared.customization.statusTextColor = .blue
        }
        let customStatusPosition = CustomizationItem("Custom position") { () -> (Void) in
            DocReader.shared.customization.showStatusMessages = true
            DocReader.shared.customization.statusPositionMultiplier = 0.5
        }
        
        let customStatusItems = [customText, customTextFont, customTextColor, customStatusPosition]
        let customStatusSection = CustomizationSection("Custom status messages", customStatusItems)
        sectionsData.append(customStatusSection)
        
        // 6. Custom result status messages
        let customResultStatusText = CustomizationItem("Custom text") { () -> (Void) in
            DocReader.shared.customization.showResultStatusMessages = true
            DocReader.shared.customization.resultStatus = "Custom result status"
        }
        let customResultStatusFont = CustomizationItem("Custom text font") { () -> (Void) in
            DocReader.shared.customization.showResultStatusMessages = true
            DocReader.shared.customization.resultStatusTextFont = UIFont.systemFont(ofSize: 24, weight: .semibold)
        }
        let customResultStatusColor = CustomizationItem("Custom text color") { () -> (Void) in
            DocReader.shared.customization.showResultStatusMessages = true
            DocReader.shared.customization.resultStatusTextColor = .blue
        }
        let customResultStatusBackColor = CustomizationItem("Custom background color") { () -> (Void) in
            DocReader.shared.customization.showResultStatusMessages = true
            DocReader.shared.customization.resultStatusBackgroundColor = .blue
        }
        let customResultStatusPosition = CustomizationItem("Custom position") { () -> (Void) in
            DocReader.shared.customization.showResultStatusMessages = true
            DocReader.shared.customization.resultStatusPositionMultiplier = 0.5
        }
        
        let customResultStatusItems = [customResultStatusText, customResultStatusFont, customResultStatusColor, customResultStatusBackColor, customResultStatusPosition]
        let customResultStatusSection = CustomizationSection("Custom result status messages", customResultStatusItems)
        sectionsData.append(customResultStatusSection)
        
        // 7. Free custom status
        let freeCustomTextAndPostion = CustomizationItem("Free text + position") { () -> (Void) in
            let fontAttributes =  [NSAttributedString.Key.foregroundColor: UIColor.red, NSAttributedString.Key.font: UIFont.italicSystemFont(ofSize: 18)]
            DocReader.shared.customization.customLabelStatus = NSAttributedString(string: "Hello, world!", attributes: fontAttributes)
            DocReader.shared.customization.customStatusPositionMultiplier = 0.5
        }
        
        let freeCustomStatusItems = [freeCustomTextAndPostion]
        let freeCustomStatusSection = CustomizationSection("Free custom status", freeCustomStatusItems)
        sectionsData.append(freeCustomStatusSection)
        
        // 8. Custom animations
        let customAnimationHelpImage = CustomizationItem("Help animation image") { () -> (Void) in
            DocReader.shared.customization.showHelpAnimation = true
            DocReader.shared.customization.helpAnimationImage = UIImage(named: "credit-card")
        }
        let customAnimationNextPageImage = CustomizationItem("Custom the next page animation") { () -> (Void) in
            DocReader.shared.customization.showNextPageAnimation = true
            DocReader.shared.customization.multipageAnimationFrontImage = UIImage(named: "1")
            DocReader.shared.customization.multipageAnimationBackImage = UIImage(named: "2")
        }
        
        let customAnimationItems = [customAnimationHelpImage, customAnimationNextPageImage]
        let customAnimationSection = CustomizationSection("Custom animations", customAnimationItems)
        sectionsData.append(customAnimationSection)
        
        // 9. Custon tint color
        let customTintColor = CustomizationItem("Activity indicator") { () -> (Void) in
            DocReader.shared.customization.activityIndicatorColor = .red
        }
        let custonNextPageButton = CustomizationItem("Next page button") { () -> (Void) in
            DocReader.shared.functionality.showSkipNextPageButton = true
            DocReader.shared.customization.multipageButtonBackgroundColor = .red
        }
        let customAllVisualElements = CustomizationItem("All visual elements") { () -> (Void) in
            DocReader.shared.customization.tintColor = .blue
        }
        
        let customTintColorItems = [customTintColor, custonNextPageButton, customAllVisualElements]
        let customTintColorSection = CustomizationSection("Custon tint color", customTintColorItems)
        sectionsData.append(customTintColorSection)
        
        // 10. Custom background
        let noBackgroundMask = CustomizationItem("No background mask") { () -> (Void) in
            DocReader.shared.customization.showBackgroundMask = false
        }
        let customBackgroundAlpha = CustomizationItem("Custom alpha") { () -> (Void) in
            DocReader.shared.customization.backgroundMaskAlpha = 0.8
        }
        let customBackgroundImage = CustomizationItem("Custom background image") { () -> (Void) in
            DocReader.shared.customization.borderBackgroundImage = UIImage(named: "viewfinder")
        }
        
        let customBackgroundItems = [noBackgroundMask, customBackgroundAlpha, customBackgroundImage]
        let customBackgroundSection = CustomizationSection("Custom background", customBackgroundItems)
        sectionsData.append(customBackgroundSection)
    }
    
    private func enableUserInterfaceOnSuccess() {
        loaderContainer.isHidden = true
        scenarioPicker.isHidden = false
        scenarioPicker.reloadAllComponents()
        tableView.isHidden = false
        settingsBarButton.isEnabled = true
        if let scenario = DocReader.shared.availableScenarios.first {
            DocReader.shared.processParams.scenario = scenario.identifier
        }
    }
    
    private func showScannerForManualMultipage() {
        DocReader.shared.showScanner(self) { [weak self] (action, result, error) in
            guard let self = self else { return }
            switch action {
            case .cancel:
                print("Cancelled by user")
                DocReader.shared.functionality.manualMultipageMode = false
            case .complete:
                guard let results = result else {
                    return
                }
                if results.morePagesAvailable != 0 {
                    // Scan next page in manual mode
                    DocReader.shared.startNewPage()
                    self.showScannerForManualMultipage()
                } else if !results.isResultsEmpty() {
                    self.showResultScreen(results)
                    DocReader.shared.functionality.manualMultipageMode = false
                }
            case .error:
                print("Error")
                guard let error = error else { return }
                print("Error string: \(error)")
            case .process:
                guard let result = result else { return }
                print("Scaning not finished. Result: \(result)")
            default:
                break
            }
        }
    }
    
    private func showAsChildViewController() {
        let mainStoryboard = UIStoryboard(name: kMainStoryboardId, bundle: nil)
        guard let childViewController = mainStoryboard.instantiateViewController(withIdentifier: kChildViewController) as? ChildViewController else {
            return
        }
        childViewController.completionHandler = { [weak self] (results) in
            guard let self = self else { return }
            if results.chipPage != 0 && ApplicationSettings.shared.isRfidEnabled {
                self.startRFIDReading(results)
            } else {
                self.showResultScreen(results)
            }
        }
        navigationController?.pushViewController(childViewController, animated: true)
    }
    
    private func startRFIDReading(_ opticalResults: DocumentReaderResults? = nil) {
        if ApplicationSettings.shared.useCustomRfidController {
            let mainStoryboard = UIStoryboard(name: kMainStoryboardId, bundle: nil)
            guard let rfidController = mainStoryboard.instantiateViewController(withIdentifier: kCustomRfidViewController) as? CustomRfidViewController else {
                return
            }
            rfidController.modalPresentationStyle = .fullScreen
            rfidController.opticalResults = opticalResults
            rfidController.completionHandler = { (results) in
                self.showResultScreen(results)
            }
            present(rfidController, animated: true, completion: nil)
        } else {
            DocReader.shared.startRFIDReader(fromPresenter: self, completion: { [weak self] (action, results, error) in
                guard let self = self else { return }
                switch action {
                case .complete:
                    guard let results = results else {
                        return
                    }
                    self.showResultScreen(results)
                case .cancel:
                    guard let results = opticalResults else {
                        return
                    }
                    self.showResultScreen(results)
                case .error:
                    print("Error")
                default:
                    break
                }
            })
        }
    }
    
    private func showResultScreen(_ results: DocumentReaderResults) {
        if ApplicationSettings.shared.isDataEncryptionEnabled {
            statusLabel.text = "Decrypting data..."
            activityIndicator.startAnimating()
            loaderContainer.isHidden = false
            processEncryptedResults(results) { decryptedResult in
                DispatchQueue.main.async {
                    self.loaderContainer.isHidden = true
                    
                    guard let results = decryptedResult else {
                        print("Can't decrypt result")
                        return
                    }
                    self.presentResults(results)
                }
            }
        } else {
            presentResults(results)
        }
    }
    
    private func presentResults(_ results: DocumentReaderResults) {
        let mainStoryboard = UIStoryboard(name: kMainStoryboardId, bundle: nil)
        guard let resultsViewController = mainStoryboard.instantiateViewController(withIdentifier: kResultsViewControllerId) as? ResultsViewController else {
            return
        }
        resultsViewController.results = results
        navigationController?.pushViewController(resultsViewController, animated: true)
    }
    
    private func showSettingsScreen() {
        let mainStoryboard = UIStoryboard(name: kMainStoryboardId, bundle: nil)
        guard let settingsViewController = mainStoryboard.instantiateViewController(withIdentifier: kSettingsViewControllerId) as? SettingsViewController else {
            return
        }
        navigationController?.pushViewController(settingsViewController, animated: true)
    }
    
    private func showHelpPopup() {
        let actionSheet = UIAlertController(title: nil, message: "Information",
                                            preferredStyle: .actionSheet)
        
        let actionDocs = UIAlertAction(title: "Documents", style: .default) { _ in
            self.openSafariWith("https://docs.regulaforensics.com/home/faq/machine-readable-travel-documents")
        }
        actionSheet.addAction(actionDocs)
        let actionCore = UIAlertAction(title: "Core", style: .default) { _ in
            self.openSafariWith("https://docs.regulaforensics.com/ios/core")
        }
        actionSheet.addAction(actionCore)
        let actionScenarios = UIAlertAction(title: "Scenarios", style: .default) { _ in
            self.openSafariWith("https://docs.regulaforensics.com/ios/scenarios")
        }
        actionSheet.addAction(actionScenarios)
        actionSheet.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        
        actionSheet.popoverPresentationController?.barButtonItem = self.helpBarButton
        present(actionSheet, animated: true, completion: nil)
    }
    
    private func openSafariWith(_ link: String) {
        guard let url = URL(string: link) else { return }
        let controller = SFSafariViewController(url: url)
        self.present(controller, animated: true, completion: nil)
    }
    
    private func showCameraViewController() {
        DocReader.shared.showScanner(self) { [weak self] (action, result, error) in
            guard let self = self else { return }
            
            switch action {
            case .cancel:
                self.stopCustomUIChanges()
                print("Cancelled by user")
            case .complete:
                self.stopCustomUIChanges()
                guard let opticalResults = result else {
                    return
                }
                if opticalResults.chipPage != 0 && ApplicationSettings.shared.isRfidEnabled {
                    self.startRFIDReading(opticalResults)
                } else {
                    self.showResultScreen(opticalResults)
                }
            case .error:
                self.stopCustomUIChanges()
                print("Error")
                guard let error = error else { return }
                print("Error string: \(error)")
            case .process:
                guard let result = result else { return }
                print("Scaning not finished. Result: \(result)")
            case .morePagesAvailable:
                print("This status couldn't be here, it uses for -recognizeImage function")
            default:
                break
            }
        }
    }
    
    private func getImageFromGallery() {
        PHPhotoLibrary.requestAuthorization { (status) in
            DispatchQueue.main.async {
                switch status {
                case .authorized:
                    if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
                        self.pickerImages.removeAll()
                        self.imagePicker.delegate = self
                        self.imagePicker.sourceType = .photoLibrary;
                        self.imagePicker.allowsEditing = false
                        self.imagePicker.navigationBar.tintColor = .black
                        self.present(self.imagePicker, animated: true, completion: nil)
                    }
                case .denied:
                    let message = NSLocalizedString("Application doesn't have permission to use the camera, please change privacy settings", comment: "Alert message when the user has denied access to the gallery")
                    let alertController = UIAlertController(title: NSLocalizedString("Gallery Unavailable", comment: "Alert eror title"), message: message, preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Alert manager, OK button tittle"), style: .cancel, handler: nil))
                    alertController.addAction(UIAlertAction(title: NSLocalizedString("Settings", comment: "Alert button to open Settings"), style: .default, handler: { action in
                        if #available(iOS 10.0, *) {
                            guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else { return }
                            UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
                        } else {
                            UIApplication.shared.openURL(URL(string: UIApplication.openSettingsURLString)!)
                        }
                    }))
                    self.present(alertController, animated: true, completion: nil)
                    print("PHPhotoLibrary status: denied")
                    break
                case .notDetermined:
                    print("PHPhotoLibrary status: notDetermined")
                case .restricted:
                    print("PHPhotoLibrary status: restricted")
                case .limited:
                    print("PHPhotoLibrary status: limited")
                @unknown default:
                    return
                }
            }
        }
    }
  
    // MARK: - Encrypted processing
    private func processEncryptedResults(_ encrypted: DocumentReaderResults, completion: ((DocumentReaderResults?) -> (Void))?) {
        let json = encrypted.rawResult
        
        let data = Data(json.utf8)

        do {
            if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                guard let containers = json["ContainerList"] as? [String: Any] else {
                    completion?(nil)
                    return
                }
                guard let list = containers["List"] as? [[String: Any]] else {
                    completion?(nil)
                    return
                }
                
                let processParam:[String: Any] = [
                    "scenario": RGL_SCENARIO_FULL_PROCESS,
                    "alreadyCropped": true
                ]
                let params:[String: Any] = [
                    "List": list,
                    "processParam": processParam
                ]
                
                guard let jsonData = try? JSONSerialization.data(withJSONObject: params, options: []) else {
                    completion?(nil)
                    return
                }
                sendDecryptionRequest(jsonData) { result in
                    completion?(result)
                }
            }
        } catch let error as NSError {
            print("Failed to load: \(error.localizedDescription)")
        }
    }
    
    private func sendDecryptionRequest(_ jsonData: Data, _ completion: ((DocumentReaderResults?) -> (Void))? ) {
        guard let url = URL(string: "https://api.regulaforensics.com/api/process") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = jsonData
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) in
            guard let jsonData = data else {
                completion?(nil)
                return
            }
            
            let decryptedResult = String(data: jsonData, encoding: .utf8)
                .flatMap { DocumentReaderResults.initWithRawString($0) }
            completion?(decryptedResult)
        })

        task.resume()
    }
    
    // MARK: - RFID additions
    
    private func getRfidCertificates(bundleName: String) -> [PKDCertificate] {
        var certificates: [PKDCertificate] = []
        let masterListURL = Bundle.main.bundleURL.appendingPathComponent(bundleName)
        do {
            let contents = try FileManager.default.contentsOfDirectory(at: masterListURL, includingPropertiesForKeys: [URLResourceKey.nameKey, URLResourceKey.isDirectoryKey], options: .skipsHiddenFiles)
            
            for content in contents {
                if let cert = try? Data(contentsOf: content)  {
                    certificates.append(PKDCertificate.init(binaryData: cert, resourceType: PKDCertificate.findResourceType(typeName: content.pathExtension), privateKey: nil))
                }
            }
        } catch {
            print(error.localizedDescription)
        }
        
        return certificates
    }
    
    func getRfidTACertificates() -> [PKDCertificate] {
        var paCertificates: [PKDCertificate] = []
        let masterListURL = Bundle.main.bundleURL.appendingPathComponent("CertificatesTA.bundle")
        do {
            let contents = try FileManager.default.contentsOfDirectory(at: masterListURL, includingPropertiesForKeys: [URLResourceKey.nameKey, URLResourceKey.isDirectoryKey], options: .skipsHiddenFiles)
            
            var filesCertMap: [String: [URL]] = [:]
            
            for content in contents {
                let fileName = content.deletingPathExtension().lastPathComponent
                if filesCertMap[fileName] == nil {
                    filesCertMap[fileName] = []
                }
                filesCertMap[fileName]?.append(content.absoluteURL)
            }
            
            for (_, certificates) in filesCertMap {
                var binaryData: Data?
                var privateKey: Data?
                for cert in certificates {
                    if let data = try? Data(contentsOf: cert) {
                        if cert.pathExtension.elementsEqual("cvCert") {
                            binaryData = data
                        } else {
                            privateKey = data
                        }
                    }
                }
                if let data = binaryData {
                    paCertificates.append(PKDCertificate.init(binaryData: data, resourceType: .certificate_TA, privateKey: privateKey))
                }
            }
        } catch {
            print(error.localizedDescription)
        }
        
        return paCertificates
    }
    
    private func setupCustomUIFromFile() {
        if let path = Bundle.main.path(forResource: "layer", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let jsonDict = try JSONSerialization.jsonObject(with: data, options: []) as? [String: AnyObject]
                DocReader.shared.customization.customUILayerJSON = jsonDict
            } catch {
                
            }
        }
    }
    
    @objc func fireTimer() {
        /*
        This example with Timer shows how you can change different properties of elements at runtime,
        such as text, position, color etc. Little bit overhead, but it show how it can changed over time.
        Also you can extend model with you properties such like ID, and access by it in runtime.
        If you don't need that kind of flexibility, you can just use a static JSON file.
        */
        guard isCustomUILayerEnabled else {
            return
        }
        
        guard let jsonData = customLayerJsonString.data(using: .utf8) else {
            return
        }
        
        guard var model = try? JSONDecoder().decode(CustomUILayerModel.self, from: jsonData) else {
            return
        }
        
        guard var object = model.objects.first else {
            return
        }
        
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        object.label.text = "Custom label that showing current time: \(dateFormatter.string(from: date))"
        
        let ct = CACurrentMediaTime()
        object.label.position.v = 1.0 + sin(ct) * 0.5 // Move vertically from 0.5 to 1.5
        
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        
        model.objects = [object]

        do {
            let data = try encoder.encode(model)
            if let jsonDict = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                DocReader.shared.customization.customUILayerJSON = jsonDict
            }
        } catch {
            
        }
    }
    
    private func stopCustomUIChanges() {
        isCustomUILayerEnabled = false
        DocReader.shared.customization.customUILayerJSON = nil
    }
}

// MARK: - UITableViewDataSource & UITableViewDelegate

extension MainViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionsData.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        sectionsData[section].items.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionsData[section].title
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kActionTableViewCellId, for: indexPath)
        
        let items = sectionsData[indexPath.section].items
        cell.textLabel?.text = items[indexPath.row].title
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = sectionsData[indexPath.section].items[indexPath.row]
        
        // Reset customization & functionality to defaults
        let defaultCustomization = Customization()
        DocReader.shared.customization = defaultCustomization
        
        if item.resetFunctionality {
            let defaultFunctionality = Functionality()
            DocReader.shared.functionality = defaultFunctionality
        }
        
        // Execute customization (action for .custom type) closure
        item.customize()
        
        switch item.actionType {
        case .scanner:
            showCameraViewController()
        case .gallery:
            getImageFromGallery()
        case .custom:
            break
        }
    }
}

// MARK: - UIPickerViewDelegate & UIPickerViewDataSource

extension MainViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        DocReader.shared.availableScenarios.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        guard DocReader.shared.availableScenarios.indices.contains(row) else { return nil }
        return DocReader.shared.availableScenarios[row].caption
    }
    
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        guard DocReader.shared.availableScenarios.indices.contains(row) else { return }
        DocReader.shared.processParams.scenario = DocReader.shared.availableScenarios[row].identifier
    }
}

// MARK: - UIImagePickerControllerDelegate & UINavigationControllerDelegate

extension MainViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        
        guard let image = info[.originalImage] as? UIImage else {
            return
        }
        pickerImages.append(image)
        
        let alert = UIAlertController(title: nil, message: "One more image?",
                                      preferredStyle: .alert)
        let addAction = UIAlertAction(title: "Yes", style: .default) { _ in
            self.present(self.imagePicker, animated: true, completion: nil)
        }
        let recognizeAction = UIAlertAction(title: "No", style: .default) { _ in
            DocReader.shared.recognizeImages(self.pickerImages, completion: { [weak self] (action, results, error) in
                guard let self = self else { return }
                if action == .complete {
                    guard let results = results else {
                        print("Completed without result")
                        return
                    }
                    self.showResultScreen(results)
                } else if action == .error {
                    print("Error")
                    guard let error = error else { return }
                    print("Error: \(error)")
                }
            })
        }

        alert.addAction(addAction)
        alert.addAction(recognizeAction)
        present(alert, animated: true, completion: nil)
    }
}

// MARK: - RGLDocReaderRFIDDelegate

extension MainViewController: RGLDocReaderRFIDDelegate {
    func onRequestPACertificates(withSerial serialNumber: Data!, issuer: PAResourcesIssuer!, callback: (([PKDCertificate]?) -> Void)!) {
        let certificates = self.getRfidCertificates(bundleName: "Certificates.bundle")
        callback(certificates)
    }
    
    func onRequestTACertificates(withKey keyCAR: String!, callback: (([PKDCertificate]?) -> Void)!) {
        let certificates = self.getRfidTACertificates()
        callback(certificates)
    }
    
    func onRequestTASignature(with challenge: TAChallenge!, callback: ((Data?) -> Void)!) {
        callback(nil)
    }
}

extension PKDCertificate {
    static func findResourceType(typeName: String) -> PKDResourceType {
        switch typeName.lowercased() {
        case "pa":
            return PKDResourceType.certificate_PA
        case "ta":
            return PKDResourceType.certificate_TA
        case "ldif":
            return PKDResourceType.LDIF
        case "crl":
            return PKDResourceType.CRL
        case "ml":
            return PKDResourceType.ML
        case "defl":
            return PKDResourceType.defL
        case "devl":
            return PKDResourceType.devL
        case "bl":
            return PKDResourceType.BL
        default:
            return PKDResourceType.certificate_PA
        }
    }
}
