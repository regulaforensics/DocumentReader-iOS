//
//  ScanViewController.swift
//  DocumentReaderSwiftBleLicense
//
//  Created by Serge Rylko on 25.11.22.
//

import UIKit
import DocumentReader

class ScanViewController: UIViewController {

    @IBOutlet private var nameLabel: UILabel!
    @IBOutlet private var portraitImageView: UIImageView!
    @IBOutlet private var authResultView: UIView!
    @IBOutlet private var authResultImageView: UIImageView!
    @IBOutlet private var documentImageView: UIImageView!
    @IBOutlet private var uvImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        resetResults()
    }
    
    private func startScan() {
        let config = DocReader.ScannerConfig(scenario: RGL_SCENARIO_FULL_AUTH)
        DocReader.shared.showScanner(presenter: self, config: config) { action, results, error in
            if action == .complete {
                if let results = results {
                    self.showAuthenticityResults(results: results)
                }
                self.startScanRFID()
            } else if let error = error  {
                print(error)
            }
        }
    }
    
    private func startScanRFID() {
        DocReader.shared.startRFIDReader(fromPresenter: self) { action, results, error in
            if action == .complete {
                if let results = results {
                    self.showGraphicResults(results: results)
                }
            } else if let error = error {
                print(error)
            }
        }
    }
    
    private func showAuthenticityResults(results: DocumentReaderResults) {
        guard let authencityResults = results.authenticityResults else { return }
        authResultView.isHidden = false
        let imageName = authencityResults.status == .ok ? "correct" : "incorrect"
        authResultImageView.image = .init(named: imageName)
            
        printAuthencityChecks(results: results)
    }
    
    private func showGraphicResults(results: DocumentReaderResults) {
        let nameField = results.getTextFieldByType(fieldType: .ft_Surname_And_Given_Names)
        nameLabel.text = nameField?.value
        
        let portraitImage = results.getGraphicFieldImageByType(fieldType: .gf_Portrait)
        let portraitRFIDImage = results.getGraphicFieldImageByType(fieldType: .gf_Portrait, source: .rfidImageData)
        portraitImageView.image = portraitRFIDImage ?? portraitImage
        
        let documentImage = results.getGraphicFieldImageByType(fieldType: .gf_DocumentImage)
        documentImageView.image = documentImage
        
        let ducumentUVImage = results.getGraphicFieldImageByType(fieldType: .gf_DocumentImage, source: .rawImage, pageIndex: 0, light: .UV)
        uvImageView.image = ducumentUVImage

        printTextFields(results: results)
    }
    
    private func resetResults() {
        nameLabel.text = nil
        portraitImageView.image = .init(named: "portrait")
        authResultView.isHidden = true
        authResultImageView.image = .init(named: "incorrect")
        documentImageView.image = nil
        uvImageView.image = nil
    }
    
    private func printTextFields(results: DocumentReaderResults) {
        results.textResult.fields.forEach { textField in
            print("Text Field: \(textField.fieldName) value: \(textField.value)")
        }
    }
    
    private func printAuthencityChecks(results: DocumentReaderResults) {
        results.authenticityResults?.checks?
            .flatMap({ $0.elements ?? []})
            .forEach({ element in
                let elementName = element.elementTypeName
                let elementStatus = element.status == .ok ? "ok" : "failed"
                if let element = element as? IdentResult {
                    let percentage = element.percentValue
                    print("Element: \(elementName), elementStatus: \(elementStatus), percent: \(percentage)")
                } else {
                    print("Element: \(elementName), elementStatus: \(elementStatus)")
                }
            })
    }
    
    //MARK: - Actions
    @IBAction private func didPressStartButton(_ sender: Any) {
        startScan()
    }
}
