//
//  ViewController.swift
//  DocumentReaderSwift-sample
//
//  Created by Dmitry Smolyakov on 6/13/17.
//  Copyright © 2017 Dmitry Smolyakov. All rights reserved.
//

import UIKit
import DocumentReader
import Photos

class ViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var documentImage: UIImageView!
    @IBOutlet weak var portraitImageView: UIImageView!

    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var userRecognizeImage: UIButton!
    @IBOutlet weak var useCameraViewControllerButton: UIButton!

    @IBOutlet weak var initializationLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    var imagePicker = UIImagePickerController()

    var docReader: DocReader?

    override func viewDidLoad() {
        super.viewDidLoad()
        initializationReader()
    }

    func initializationReader() {
        //initialize license
        guard let dataPath = Bundle.main.path(forResource: "regula.license", ofType: nil) else { return }
        guard let licenseData = try? Data(contentsOf: URL(fileURLWithPath: dataPath)) else { return }

        //create DocReader object
        let docReader = DocReader()

        docReader.initilizeReader(license: licenseData) { (successfull, error) in
            if successfull {
                self.activityIndicator.stopAnimating()
                self.initializationLabel.isHidden = true
                self.userRecognizeImage.isHidden = false
                self.useCameraViewControllerButton.isHidden = false
                self.pickerView.isHidden = false
                self.pickerView.reloadAllComponents()
                self.pickerView.selectRow(0, inComponent: 0, animated: false)

                //Get available scenarios
                for scenario in docReader.availableScenarios {
                    print(scenario)
                    print("--------")
                }
            } else {
                self.activityIndicator.stopAnimating()
                let licenseError = error ?? "Unknown error"
                self.initializationLabel.text = "Initialization error: \(licenseError)"
                print(licenseError)
            }
        }

        //set scenario
        docReader.processParams.scenario = "Mrz"
        self.docReader = docReader
    }

    // Use this code for recognize on photo from camera
    @IBAction func useCameraViewController(_ sender: UIButton) {
        //start recognize
        docReader?.showScanner(self) { (action, result, error) in
            switch action {
            case .cancel:
                print("Cancelled by user")
            case .complete:
                print("Completed")
                self.handleResult(result: result)
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
        self.documentImage.image = result.getGraphicFieldImageByType(fieldType: .gf_DocumentFront, source: .rawImage)
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
        PHPhotoLibrary .requestAuthorization { (status) in
            switch status {
            case .authorized:
                if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
                    self.imagePicker.delegate = self
                    self.imagePicker.sourceType = .photoLibrary;
                    self.imagePicker.allowsEditing = false
                    DispatchQueue.main.async {
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
                        guard let settingsURL = URL(string: UIApplicationOpenSettingsURLString) else { return }
                        UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
                    } else {
                        UIApplication.shared.openURL(URL(string: UIApplicationOpenSettingsURLString)!)
                    }
                }))
                self.present(alertController, animated: true, completion: nil)
                print("PHPhotoLibrary status: denied")
                break
            case .notDetermined:
                print("PHPhotoLibrary status: notDetermined")
            case .restricted:
                print("PHPhotoLibrary status: restricted")
            }
        }
    }

}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.dismiss(animated: true, completion: {

                //start recognize
                self.docReader?.recognizeImage(image, completion: { (action, result, error) in
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

extension ViewController: UIPickerViewDataSource {
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        guard let docReader = docReader else { return 0 }
        return docReader.availableScenarios.count
    }
}

extension ViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return docReader?.availableScenarios[row].identifier
    }

    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        guard let docReader = docReader else { return }
        self.docReader?.processParams.scenario = docReader.availableScenarios[row].identifier
    }
}

