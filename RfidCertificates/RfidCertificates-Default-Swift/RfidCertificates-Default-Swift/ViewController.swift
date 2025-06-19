//
//  ViewController.swift
//  RfidCertificates-Default-Swift
//
//  Created by Dmitry Evglevsky on 22.03.23.
//  Copyright © 2023 Regula. All rights reserved.
//

import UIKit
import DocumentReader

class ViewController: UIViewController {
    @IBOutlet weak var paStatusLabel: UILabel!
    @IBOutlet weak var portraitImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializeDocumentReader()
    }
    
    func initializeDocumentReader() {
        guard let dataPath = Bundle.main.path(forResource: kRegulaLicenseFile, ofType: nil) else {
            print("Missing Licence File in Bundle")
            return
        }
        
        guard let licenseData = try? Data(contentsOf: URL(fileURLWithPath: dataPath)) else {
            print("Missing Licence File in Bundle")
            return
        }

        let config = DocReader.Config(license: licenseData)

        DocReader.shared.initializeReader(config: config, completion: { (success, error) in
            DispatchQueue.main.async {
                if success {
                    print("DocumentReader initialized")
                    if DocReader.shared.isRFIDAvailableForUse {
                        DocReader.shared.addPKDCertificates(certificates: self.getRfidCertificates(bundleName: "Certificates.bundle"))
                    }
                } else {
                    print("Initialization error: \(error?.localizedDescription ?? "nil")")
                }
            }
        })
    }
    
    func displayText(results: DocumentReaderResults?) {
        paStatusLabel.text = "PA Status:"
        
        guard let results = results else {
            return
        }

        paStatusLabel.text = "PA Status: " + results.status.detailsRFID.pa.stringStatus
    }
    
    func displayPortrait(results: DocumentReaderResults?) {
        guard let results = results else {
            return
        }
        
        guard let image = results.getGraphicFieldImageByType(fieldType: .gf_Portrait) else {
            return
        }
        
        portraitImageView.contentMode = .scaleAspectFit
        portraitImageView.image = image
    }
    
    func startRFID() {
        DocReader.shared.startRFIDReader(fromPresenter: self) { action, results, error in
            switch action {
            case .complete:
                // Processing finished, results are ready
                self.displayText(results: results)
                self.displayPortrait(results: results)
                break
            case .cancel:
                print("RFID scanning was cancelled")
                break
            case .error:
                print("Error: \(error?.localizedDescription ?? "unknown")")
                break
            default:
                break
            }
        }
    }

    @IBAction func showScannerPressed(_ sender: UIButton) {
        let config = DocReader.ScannerConfig(scenario: RGL_SCENARIO_MRZ)
        DocReader.shared.startScanner(presenter: self, config: config) { action, results, error in
            switch action {
            case .complete:
                self.startRFID()
                break
            case .cancel:
                print("Scanning was cancelled")
                break
            case .error:
                print("Error: \(error?.localizedDescription ?? "unknown")")
                break
            default:
                break
            }
        }
    }
    
    private func getRfidCertificates(bundleName: String) -> [PKDCertificate] {
        var certificates: [PKDCertificate] = []
        let masterListURL = Bundle.main.bundleURL.appendingPathComponent(bundleName)
        do {
            let contents = try FileManager.default.contentsOfDirectory(at: masterListURL, includingPropertiesForKeys: [URLResourceKey.nameKey, URLResourceKey.isDirectoryKey], options: .skipsHiddenFiles)
            
            for content in contents {
                if let cert = try? Data(contentsOf: content)  {
                    let resourceType = PKDCertificate.findResourceType(typeName: content.pathExtension)
                    certificates.append(PKDCertificate.init(binaryData: cert, resourceType: resourceType, privateKey: nil))
                }
            }
        } catch {
            print(error.localizedDescription)
        }
        
        return certificates
    }
    
}

extension CheckResult {
    var stringStatus: String {
        switch self {
        case .error:
            return "error"
        case .ok:
            return "ok"
        case .wasNotDone:
            return "check was not done"
        @unknown default:
            return ""
        }
    }
}
