//
//  ViewController.swift
//  DocumentReaderSwiftBleLicense
//
//  Created by Serge Rylko on 24.11.22.
//

import UIKit
import DocumentReader

class ViewController: UIViewController {
    
    enum ReaderState {
        case none
        case initializing
        case initialized
        case error(Error)
    }
    
    @IBOutlet private var searchTextField: UITextField!
    @IBOutlet private var statusLabel: UILabel!
    @IBOutlet private var loaddingIndicator: UIActivityIndicatorView!
    @IBOutlet private var connectButton: UIButton!
    
    private var state: ReaderState = .none {
        didSet { handleReaderState(oldValue: oldValue) }
    }
    private var deviceName: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchTextField.text = "Regula 4444"
    }
    
    private func connectToDevice() {
        guard let deviceName = deviceName, deviceName.isEmpty == false else { return }
        let bluetooth = Bluetooth()
        bluetooth.connect(withDeviceName: deviceName)
        let config = DocReader.BleConfig(bluetooth: bluetooth)
        initializeReader(withConfig: config)
    }
    
    private func initializeReader(withConfig config: DocReader.BleConfig) {
        state = .initializing
        
        DocReader.shared.initializeReader(config: config) { success, error in
            if success {
                self.setupFunctionality()
                self.state = .initialized
                self.navigateToScan()
            } else if let error = error {
                self.state = .error(error)
            }
        }
    }
    
    private func setupFunctionality() {
        DocReader.shared.functionality.isUseAuthenticator = true
    }
    
    private func navigateToScan() {
        let vc = UIStoryboard.init(name: "Main", bundle:.main)
            .instantiateViewController(withIdentifier: "ScanViewController")
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func handleReaderState(oldValue: ReaderState) {
        guard state != oldValue else { return }
        DispatchQueue.main.async {
            switch self.state {
            case .none: break
            case .initializing:
                self.displayInitalizing()
                self.displayLoading(isLoading: true)
            case .initialized:
                self.displayInitalized()
                self.displayLoading(isLoading: false)
            case .error(let error):
                self.display(error: error)
                self.displayLoading(isLoading: false)
            }
        }
    }
    
    //MARK: Statuses
    private func display(progress: Double) {
      let roundedProgress = round(progress * 1000)/10
      statusLabel.text = "loading: \(roundedProgress) %"
    }
    
    private func display(error: Error) {
        statusLabel.text = "error: \(error.localizedDescription)"
    }
    
    private func displayDBReady() {
        statusLabel.text = "database is ready"
    }
    
    private func displayInitalizing() {
        statusLabel.text = "initializing"
    }
    
    private func displayInitalized() {
        statusLabel.text = "initialized"
    }
    
    private func displayLoading(isLoading: Bool) {
        if isLoading {
            loaddingIndicator.startAnimating()
        } else {
            loaddingIndicator.stopAnimating()
        }
        connectButton.isEnabled = !isLoading
    }
    
    //MARK: - Actions
    @IBAction private func didPressConnectButton(_ sender: Any) {
        deviceName = searchTextField.text
        connectToDevice()
    }
}

extension UIViewController: UITextFieldDelegate {
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
}

extension ViewController.ReaderState: Equatable {
    static func == (lhs: ViewController.ReaderState, rhs: ViewController.ReaderState) -> Bool {
        switch (lhs, rhs) {
        case (.none, .none): return true
        case (.initializing, .initializing): return true
        case (.initialized, .initialized): return true
        case (.error(let error1), .error(let error2)):
            return error1.localizedDescription == error2.localizedDescription
        default: return false
        }
    }
}
