//
//  ViewController.swift
//  DocumentReaderFullSwift-sample
//
//  Created by Dmitry Smolyakov on 9/21/18.
//  Copyright © 2018 Dmitry Smolyakov. All rights reserved.
//

import UIKit
import DocumentReader

class ViewController: UIViewController {

    @IBOutlet private var resultLabel: UILabel!
    @IBOutlet weak var initButton: UIButton!
    @IBOutlet weak var deinitButton: UIButton!
  
    private let databaseID = "Full"
    private var selectedScenario: String?
    private weak var alertViewController: UIAlertController?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if Bundle.main.path(forResource: "regula.license", ofType: nil) == nil {
            initButton.isEnabled = false
            deinitButton.isEnabled = false
        }
    }

    @IBAction private func didPressPrepareDatabase(sender: Any) {
        let cancel = { DocReader.shared.cancelDBUpdate() }
        displayAlert(title: "Prepare database", cancel: cancel)

        DocReader.shared.prepareDatabase(databaseID: databaseID) { [weak self] progress in
            self?.updateAlertLoadingMessage(progress: progress)
        } completion: { [weak self] success, error in
            DispatchQueue.main.async {
                self?.dismiss(animated: true)
                if success {
                    self?.resultLabel.text = "Database prepared"
                    self?.initButton.isEnabled = true
                } else if let error = error {
                    self?.resultLabel.text = "Database prepare error: \(error.localizedDescription)"
                }
            }
        }
    }

    @IBAction private func didPressRemoveDatabase(sender: Any) {
        DocReader.shared.removeDatabase { [weak self] success, error in
            if success {
                self?.resultLabel.text = "Database removed"
                self?.initButton.isEnabled = false
            } else if let error = error {
                self?.resultLabel.text = "Database remove error: \(error.localizedDescription)"
            }
        }
    }

    @IBAction private func didPressCheckDatabaseUpdate(sender: Any) {
        DocReader.shared.checkDatabaseUpdate(databaseID: databaseID) { [weak self] database in
            DispatchQueue.main.async {
                if let database = database {
                    self?.displayDatabaseStatus(database: database)
                } else {
                    self?.resultLabel.text = "No updates"
                }
            }
        }
    }

    @IBAction private func didPressRunAutoUpdateDatabase(sender: Any) {
        let cancel = { DocReader.shared.cancelDBUpdate() }
        displayAlert(title: "Auto update database", cancel: cancel)

        DocReader.shared.runAutoUpdate(databaseID: databaseID) { [weak self] progress in
            self?.updateAlertLoadingMessage(progress: progress)
        } completion: { [weak self] success, error in
            DispatchQueue.main.async {
                self?.dismiss(animated: true)
                if success {
                    self?.resultLabel.text = "Database prepared"
                    self?.initButton.isEnabled = true
                } else if let error = error {
                    self?.resultLabel.text = "Database prepare error: \(error.localizedDescription)"
                }
            }
        }
    }

    @IBAction private func didTapInitializeReader(_ sender: Any) {
        guard let dataPath = Bundle.main.path(forResource: "regula.license", ofType: nil) else { return }
        guard let licenseData = try? Data(contentsOf: URL(fileURLWithPath: dataPath)) else { return }

        let config = DocReader.Config(license: licenseData)
        DocReader.shared.initializeReader(config: config) { (success, error) in
            if success {
                self.resultLabel.text = "Reader initialized"
                self.deinitButton.isEnabled = true
            } else if let error = error {
                self.resultLabel.text = "Reader initialize error: \(error.localizedDescription)"
                self.deinitButton.isEnabled = false
            }
        }
    }

    @IBAction private func didTapDeinitializeReader(_ sender: Any) {
        DocReader.shared.deinitializeReader()
        resultLabel.text = "Reader deinitialized"
        deinitButton.isEnabled = false
    }

    private func displayAlert(title: String, cancel: (() -> Void)?) {
        let alert = UIAlertController(title: title, message: "Download", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            cancel?()
        }
        alert.addAction(cancelAction)
        alertViewController = alert
        present(alert, animated: true)
    }

    private func displayDatabaseStatus(database: DocReaderDocumentsDatabase) {
        let formatter = ByteCountFormatter()

        let version = "version: \(database.version ?? "")"
        let date = "date: \(database.date ?? "")"
        let description = database.description
        let size = database.size ?? 0
        let formattedSize = formatter.string(fromByteCount: size.int64Value)
        let sizeInfo = "size: \(formattedSize)"
        let resultString = [version, date, description, sizeInfo]
            .compactMap({ $0 })
            .joined(separator: "\n")
        
        DispatchQueue.main.async {
            self.resultLabel.text = resultString
        }
    }

    private func updateAlertLoadingMessage(progress: Progress) {
        let byteFormatterNoUnits = ByteCountFormatter()
        byteFormatterNoUnits.includesUnit = false
        byteFormatterNoUnits.zeroPadsFractionDigits = true

        let byteFormatter = ByteCountFormatter()
        byteFormatter.includesUnit = true

        let completed = byteFormatterNoUnits.string(fromByteCount: progress.completedUnitCount)
        let total = byteFormatter.string(fromByteCount: progress.totalUnitCount)
        let downloading = "Downloading database:"
        let persent = (progress.fractionCompleted * 100).rounded()
        let status = "\(downloading) \n \(completed) / \(total) - \(persent)%"
        self.alertViewController?.message = status
    }
}
