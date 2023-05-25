//
//  CustomRfidViewController.swift
//  DocumentReader-Swift
//
//  Created by Dmitry Smolyakov on 10/8/19.
//  Copyright © 2019 Dmitry Smolyakov. All rights reserved.
//

import UIKit
import DocumentReader

class CustomRfidViewController: UIViewController {
    
    var opticalResults: DocumentReaderResults? = nil
    var completionHandler: DocumentReaderResultsClosure? = nil

    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var currentStatusLabel: UILabel!
    @IBOutlet weak var rfidStateLabel: UILabel!
    @IBOutlet weak var rfidImageView: UIImageView! {
        didSet {
            rfidImageView.image = rfidImageView.image?.withRenderingMode(.alwaysTemplate)
        }
    }
    
    var currentRfidNotify: RFIDNotify? {
        didSet {
            DispatchQueue.main.async {
                self.currentStatusLabel.text = self.currentDataGroupTypeName()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // if you want to use Regula 1129 authenticator
//        DocReader.shared.functionality.isUseAuthenticator = true
//        DocReader.shared.functionality.btDeviceName = "Regula 0122"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startReadRFID()
    }
    
    @IBAction func closeTapped(_ sender: Any) {
        DocReader.shared.stopRFIDReader(nil)
        if let results = opticalResults {
            completionHandler?(results)
        }
        dismiss(animated: true, completion: nil)
    }
    
    func startReadRFID() {
        DocReader.shared.readRFID({ (action, notification) in
            switch action {
            case .searchingTag:
                DocReader.shared.rfidSessionStatus = "Place your document on the device (custom)"
            case .startReading:
                DocReader.shared.rfidSessionStatus = "Reading RFID chip data (custom)"
                DispatchQueue.main.async {
                    self.rfidImageView.tintColor = UIColor.yellow
                    self.rfidStateLabel.text = "Reading RFID chip data"
                    self.currentStatusLabel.isHidden = false
                    self.progressView.isHidden = false
                }
            case .notification:
                guard let notify = notification else {
                    return
                }
                self.handleRFIDNotify(rfidNotify: notify)
                let status = self.currentDataGroupTypeName()
                if !status.isEmpty {
                    DocReader.shared.rfidSessionStatus = "\(status)\nProgress:\(self.currentProgress(rfidNotify: notify))"
                }
                DispatchQueue.main.async {
                    self.currentStatusLabel.text = status
                }
            default:
                break
            }
        }) { (action, results, error, errorCode) in
            switch action {
            case .complete:
                DocReader.shared.rfidSessionStatus = "RFID data reading is finished (custom)"
                guard let results = results, !results.isResultsEmpty() else {
                    return
                }
                self.completionHandler?(results)
                self.dismiss(animated: true, completion: nil)
            case .error:
                self.rfidImageView.tintColor = UIColor.red
                if let err = error {
                    let newError = "RFID Failed: \(err) (custom)"
                    self.rfidStateLabel.text = err.localizedDescription
                    DocReader.shared.rfidSessionStatus = newError
                }
            case .sessionRestarted:
                if let error = RFIDNotify.rfidErrorCodesName(errorCode) {
                     let newError = "RFID Failed: \(error) (custom)"
                    self.rfidStateLabel.text = error
                    DocReader.shared.rfidSessionStatus = newError
                }
                self.rfidImageView.tintColor = UIColor.red
                self.currentStatusLabel.isHidden = true
                self.progressView.isHidden = true
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
                    self.rfidImageView.tintColor = UIColor.black
                    self.rfidStateLabel.text = "Place your document on the device (custom)"
                    DocReader.shared.rfidSessionStatus = self.rfidStateLabel.text
                }
            case .cancel:
                if let results = self.opticalResults {
                    self.completionHandler?(results)
                }
                self.dismiss(animated: true, completion: nil)
            default:
                break
            }
        }
    }
    
    func handleRFIDNotify(rfidNotify: RFIDNotify) {
        switch rfidNotify.code {
        case RFIDNotificationCodes.progress:
            DispatchQueue.main.async {
                var progress: Float = 0
                if self.currentRfidNotify != nil {
                    progress = Float(rfidNotify.value / 100)
                }
                self.progressView.progress = progress
            }
        case RFIDNotificationCodes.pcscReadingDatagroup:
            if rfidNotify.value == 1 {
                self.currentRfidNotify = nil
            } else {
                self.currentRfidNotify = rfidNotify
            }
        default:
            break
        }
    }
    
    func currentProgress(rfidNotify: RFIDNotify) -> Float {
        switch rfidNotify.code {
        case RFIDNotificationCodes.progress:
            return Float(rfidNotify.value)
        default:
            break
        }
        
        return 0
    }
    
    func currentDataGroupTypeName() -> String {
        if let notify = self.currentRfidNotify {
            let type = RFIDDataFileType(rawValue: notify.attachment) ?? .unspecified
            return RFIDNotify.rfidDataFileTypeName(type) ?? ""
        }
        return ""
    }
}
