//
//  ViewController.swift
//  DocumentReaderFullSwift-sample
//
//  Created by Dmitry Smolyakov on 9/21/18.
//  Copyright © 2018 Dmitry Smolyakov. All rights reserved.
//

import UIKit
import DocumentReader
import Photos

class ViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var documentImage: UIImageView!
    @IBOutlet weak var portraitImageView: UIImageView!
    
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var userRecognizeImageButton: UIButton!
    @IBOutlet weak var useCameraViewControllerButton: UIButton!
    @IBOutlet weak var readRDFButton: UIButton!


    @IBOutlet weak var initializationLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var readRFIDLabel: UILabel!
    @IBOutlet weak var readRFID: UISwitch!
      
    var imagePicker = UIImagePickerController()
    
    private var selectedScenario: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializationReader()
    }
    
    func initializationReader() {
        // getting license
        guard let dataPath = Bundle.main.path(forResource: "regula.license", ofType: nil) else { return }
        guard let licenseData = try? Data(contentsOf: URL(fileURLWithPath: dataPath)) else { return }

        let config = DocReader.Config(license: licenseData)
        DocReader.shared.initializeReader(config: config) { (success, error) in
            DispatchQueue.main.async {
                if success {
                    self.activityIndicator.stopAnimating()
                    self.initializationLabel.isHidden = true
                    self.userRecognizeImageButton.isHidden = false
                    self.useCameraViewControllerButton.isHidden = false
                    self.readRDFButton.isHidden = false

                    if DocReader.shared.isRFIDAvailableForUse {
                        self.readRFIDLabel.isHidden = false
                        self.readRFID.isHidden = false
                    }

                    self.pickerView.isHidden = false
                    self.pickerView.reloadAllComponents()
                    self.pickerView.selectRow(0, inComponent: 0, animated: false)

                    //set scenario
                    if let firstScenario = DocReader.shared.availableScenarios.first {
                        self.selectedScenario = firstScenario.identifier
                    }

                } else {
                    self.activityIndicator.stopAnimating()
                    self.initializationLabel.text = "Initialization error: \(error?.localizedDescription ?? "unknown")"
                    print(error?.localizedDescription ?? "unknown")
                }
            }
        }
    }
    
    @IBAction func useCameraViewController(_ sender: UIButton) {
        guard let selectedScenario = selectedScenario else { return }
        let config = DocReader.ScannerConfig(scenario: selectedScenario)
        
        DocReader.shared.startScanner(presenter: self, config: config) { (action, result, error) in
            if action == .complete {
                print("Completed")
                if self.readRFID.isOn && result?.chipPage != 0 {
                    self.startRFIDReading()
                } else {
                    self.handleResult(result: result)
                }
            } else if action == .processTimeout {
                print("Timeout")
                let timeoutLabel = UILabel(frame: self.view.bounds)
                timeoutLabel.text = "Timeout!"
                timeoutLabel.font = UIFont.systemFont(ofSize: 22, weight: .medium)
                timeoutLabel.textAlignment = .center
                self.view.addSubview(timeoutLabel)
                UIView.animate(withDuration: 2) {
                    timeoutLabel.alpha = 0
                } completion: { completion in
                    timeoutLabel.removeFromSuperview()
                    self.handleResult(result: result)
                }
            } else if action == .error {
                print("Error")
                guard let error = error else { return }
                print("Error string: \(error)")
            } else if action == .process {
                guard let result = result else { return }
                print("Scaning not finished. Result: \(result)")
            } else {
                guard let result = result else { return }
                print("Results: \(result), action: \(action)")
            }
        }
    }
    
    func handleResult(result: DocumentReaderResults?) {
        guard let result = result else { return }
        print("Result class: \(result)")
        
        let name = result.getTextFieldValueByType(fieldType: .ft_Surname_And_Given_Names)
        print("NAME: \(name ?? "empty field")")
        
        self.nameLabel.text = name
        self.documentImage.image = result.getGraphicFieldImageByType(fieldType: .gf_DocumentImage, source: .rawImage)
        self.portraitImageView.image = result.getGraphicFieldImageByType(fieldType: .gf_Portrait)
        
        for textField in result.textResult.fields {
            for value in textField.values {
                print("\(textField.fieldName) -> value: \(value.value), source: \(value.sourceType.rawValue), lcid: \(textField.lcid.rawValue), pageIndex: \(value.pageIndex)")
            }
        }
    }
    
    @IBAction func useRecognizeImageMethod(_ sender: UIButton) {
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
                DispatchQueue.main.async {
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
                }
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

    @IBAction private func didPressRecognizePDF(_ sender: Any) {
        guard let path = Bundle.main.url(forResource: "test", withExtension: "pdf") else { return }
        guard let data = try? Data(contentsOf: path) else { return }
        let config = DocReader.RecognizeConfig(imageData: data)
        config.scenario = self.selectedScenario
        DocReader.shared.recognize(config: config) { action, results, error in
            self.handleResult(result: results)
        }
    }

    func startRFIDReading() {
        DocReader.shared.startRFIDReader(fromPresenter: self, completion: { (action, results, error) in
            switch action {
            case .complete:
                print("complete")
                self.handleResult(result: results)
            case .cancel:
                print("Canceled")
            case .error:
                print("Error")
                self.nameLabel.text = error?.localizedDescription
            default:
                break
            }
        })
    }
    
}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedScenario = selectedScenario else { return }
        let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)

        if let image = info[convertFromUIImagePickerControllerInfoKey(.originalImage)] as? UIImage {
            self.dismiss(animated: true, completion: {
                
                let config = DocReader.RecognizeConfig(scenario: selectedScenario)
                config.image = image

                DocReader.shared.recognize(config: config) { (action, result, error) in
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
                }

            })
        } else {
            self.dismiss(animated: true, completion: nil)
            print("Something went wrong")
        }
    }
}

extension ViewController: UIPickerViewDataSource {
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return DocReader.shared.availableScenarios.count
    }
}

extension ViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return DocReader.shared.availableScenarios[row].identifier
    }
    
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedScenario = DocReader.shared.availableScenarios[row].identifier
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
