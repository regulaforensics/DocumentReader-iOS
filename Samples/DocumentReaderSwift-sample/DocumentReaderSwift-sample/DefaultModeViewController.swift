//
//  DefaultModeViewController.swift
//  DocumentReaderFullSwift-sample
//
//  Created by Dmitry Smolyakov on 9/21/18.
//  Copyright © 2018 Dmitry Smolyakov. All rights reserved.
//

import UIKit
import DocumentReader
import Photos

class DefaultModeViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var documentImage: UIImageView!
    @IBOutlet weak var portraitImageView: UIImageView!
    
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var userRecognizeImage: UIButton!
    @IBOutlet weak var useCameraViewControllerButton: UIButton!
    
    @IBOutlet weak var initializationLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var readRFIDLabel: UILabel!
    @IBOutlet weak var readRFID: UISwitch!
  
    var customRfid = false
    
    var imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializationReader()
    }
    
    func initializationReader() {
        //initialize license
        guard let dataPath = Bundle.main.path(forResource: "regula.license", ofType: nil) else { return }
        guard let licenseData = try? Data(contentsOf: URL(fileURLWithPath: dataPath)) else { return }
        
        DispatchQueue.global().async {
            
            DocReader.shared.prepareDatabase(databaseID: "Full", progressHandler: { (progress) in
                let progressValue = String(format: "%.1f", progress.fractionCompleted * 100)
                self.initializationLabel.text = "Downloading database: \(progressValue)%"
            }, completion: { (successfull, error) in
                DocReader.shared.initializeReader(license: licenseData) { (successfull, error) in
                    DispatchQueue.main.async {
                        if successfull {
                            self.activityIndicator.stopAnimating()
                            self.initializationLabel.isHidden = true
                            self.userRecognizeImage.isHidden = false
                            self.useCameraViewControllerButton.isHidden = false
                            
                            if DocReader.shared.isRFIDAvailableForUse {
                                self.readRFIDLabel.isHidden = false
                                self.readRFID.isHidden = false
                            }
                            
                            self.pickerView.isHidden = false
                            self.pickerView.reloadAllComponents()
                            self.pickerView.selectRow(0, inComponent: 0, animated: false)
                          
                            //set scenario
                            if let firstScenario = DocReader.shared.availableScenarios.first {
                              DocReader.shared.processParams.scenario = firstScenario.identifier
                            }
                            DocReader.shared.functionality.singleResult = true
                          
                            //Get available scenarios
                            for scenario in DocReader.shared.availableScenarios {
                                print(scenario)
                                print("--------")
                            }
                            
                            // add cerificates. Don't forget to comment set up of rfidDelegate below if this option is used
//                            let certificates = self.getRfidCertificates(bundleName: "Certificates.bundle")
//                            if certificates.count > 0 {
//                                DocReader.shared.addPKDCertificates(certificates: certificates)
//                            }
                                                        
                            // set up delegate to get request for certificates in runtime. Don't forget to comment 3 lines above if this option is used
//                            DocReader.shared.rfidDelegate = self;
                        } else {
                            self.activityIndicator.stopAnimating()
                            self.initializationLabel.text = "Initialization error: \(error?.localizedDescription)"
                            print(error?.localizedDescription)
                        }
                    }
                }
            })
        }
    }
    
    // Use this code for recognize on photo from camera
    @IBAction func useCameraViewController(_ sender: UIButton) {
        //start recognize
        DocReader.shared.showScanner(self) { (action, result, error) in
            switch action {
            case .cancel:
                print("Cancelled by user")
            case .complete:
                print("Completed")
                if self.readRFID.isOn && result?.chipPage != 0 {
                    self.startRFIDReading()
                } else {
                    self.handleResult(result: result)
                }
            case .error:
                print("Error")
                guard let error = error else { return }
                print("Error string: \(error)")
            case .process:
                guard let result = result else { return }
                print("Scaning not finished. Result: \(result)")
            case .morePagesAvailable:
                print("This status couldn't be here, it uses for -recognizeImage function")
            }
        }
    }
    
    func handleResult(result: DocumentReaderResults?) {
        guard let result = result else { return }
        print("Result class: \(result)")
        // use fast getValue method
        let name = result.getTextFieldValueByType(fieldType: .ft_Surname_And_Given_Names)
        print("NAME: \(name ?? "empty field")")
        self.nameLabel.text = name
        self.documentImage.image = result.getGraphicFieldImageByType(fieldType: .gf_DocumentImage, source: .rawImage)
        self.portraitImageView.image = result.getGraphicFieldImageByType(fieldType: .gf_Portrait)
        
        //go though all text results
        for textField in result.textResult.fields {
            guard let value = result.getTextFieldValueByType(fieldType: textField.fieldType, lcid: textField.lcid) else { continue }
            print("Field type name: \(textField.fieldName), value: \(value)")
        }
    }
    
    // Use this code for recognize on photo from gallery
    @IBAction func useRecognizeImageMethod(_ sender: UIButton) {
        //load image from assets folder
        getImageFromGallery()
    }
    
    func getImageFromGallery() {
        PHPhotoLibrary.requestAuthorization { (status) in
            switch status {
            case .authorized:
                if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
                  DispatchQueue.main.async {
                    self.imagePicker.delegate = self
                    self.imagePicker.sourceType = .photoLibrary;
                    self.imagePicker.allowsEditing = false
                    self.imagePicker.navigationBar.tintColor = .black
                    self.present(self.imagePicker, animated: true, completion: nil)
                  }
                }
            case .denied:
                let message = NSLocalizedString("Application doesn't have permission to use the camera, please change privacy settings", comment: "Alert message when the user has denied access to the gallery")
                let alertController = UIAlertController(title: NSLocalizedString("Gallery Unavailable", comment: "Alert eror title"), message: message, preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Alert manager, OK button tittle"), style: .cancel, handler: nil))
                alertController.addAction(UIAlertAction(title: NSLocalizedString("Settings", comment: "Alert button to open Settings"), style: .default, handler: { action in
                    if #available(iOS 10.0, *) {
                        guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else { return }
                        UIApplication.shared.open(settingsURL, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
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
            }
        }
    }
    
    func startRFIDReading() {
        if customRfid {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "CustomRfidViewController")
            controller.modalPresentationStyle = .fullScreen
            self.present(controller, animated: true, completion: nil)
        } else {
            DocReader.shared.startRFIDReader(fromPresenter: self, completion: { (action, results, error) in
                switch action {
                case .complete:
                    print("complete")
                    self.handleResult(result: results)
                case .cancel:
                    print("Cancelled")
                case .error:
                    print("Error")
                    self.nameLabel.text = error?.localizedDescription
                default:
                    break
                }
            })
        }
    }
    
    func getRfidCertificates(bundleName: String) -> [PKDCertificate] {
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
}

extension DefaultModeViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)

        if let image = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as? UIImage {
            self.dismiss(animated: true, completion: {

                //start recognize
                DocReader.shared.recognizeImage(image, completion: { (action, result, error) in
                    if action == .complete {
                        if result != nil {
                            print("Completed")
                            print("Result class: \(result!)")
                            self.handleResult(result: result)
                        } else {
                            print("Completed without result")
                        }
                    } else if action == .error {
                        print("Eror")
                        guard let error = error else { return }
                        print("Eror: \(error)")
                    }
                })

            })
        } else {
            self.dismiss(animated: true, completion: nil)
            print("Something went wrong")
        }
    }
}

extension DefaultModeViewController: UIPickerViewDataSource {
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return DocReader.shared.availableScenarios.count
    }
}

extension DefaultModeViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return DocReader.shared.availableScenarios[row].identifier
    }
    
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        DocReader.shared.processParams.scenario = DocReader.shared.availableScenarios[row].identifier
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

extension DefaultModeViewController: RGLDocReaderRFIDDelegate {
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


// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
    return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
    return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
    return input.rawValue
}
