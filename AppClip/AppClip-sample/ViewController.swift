//
//  ViewController.swift
//  AppClip-sample
//
//  Created by Ihar Yalavoi on 18.12.25.
//  Copyright © 2025 Dmitry Smolyakov. All rights reserved.
//

import UIKit
import DocumentReader

class ViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - Properties
    
    private var configURL: URL?
    private let chipVerificationBool = false
    private var isInitializationStarted = false
    private var currentAlert: UIAlertController?
    private var selectedScenario: String = RGL_SCENARIO_MRZ_AND_LOCATE
    
    // MARK: - Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkForPendingURL()
        
        guard configURL != nil, !isInitializationStarted else { return }
        if let alert = currentAlert {
            alert.dismiss(animated: false) { [weak self] in
                self?.currentAlert = nil
                self?.startInitializationIfNeeded()
            }
        } else {
            startInitializationIfNeeded()
        }
    }
    
    private func checkForPendingURL() {
        if configURL == nil, let qrCodeURLString = UserDefaults.standard.string(forKey: "AppClipPendingURL"),
           let qrCodeURL = URL(string: qrCodeURLString) {
            print("Found QR code URL in UserDefaults: \(qrCodeURLString)")
            configURL = qrCodeURL
            UserDefaults.standard.removeObject(forKey: "AppClipPendingURL")
            
            if !isInitializationStarted { startInitializationIfNeeded() }
        }
    }
    
    // MARK: - Public Methods
    
    /// Sets the configuration URL from QR code scan
    /// Called from SceneDelegate when App Clip is invoked
    func setConfigURL(_ url: URL) {
        print("Config URL set from SceneDelegate: \(url.absoluteString)")
        print("Current state - isViewLoaded: \(isViewLoaded), view.window: \(view.window != nil), isInitializationStarted: \(isInitializationStarted), existing configURL: \(configURL?.absoluteString ?? "nil")")
        
        if isInitializationStarted { isInitializationStarted = false }
        currentAlert?.dismiss(animated: false) { [weak self] in self?.currentAlert = nil }
        configURL = url
        if isViewLoaded {
            DispatchQueue.main.async { self.startInitializationIfNeeded() }
        }
    }
    
    private func startInitializationIfNeeded() {
        guard !isInitializationStarted else {
            print("Initialization already started, skipping")
            return
        }
        
        guard let url = configURL else {
            print("No config URL available yet, waiting...")
            return
        }
        
        guard Thread.isMainThread else {
            return DispatchQueue.main.async { self.startInitializationIfNeeded() }
        }
        
        isInitializationStarted = true
        print("[Log] Reader init with URL: \(url.absoluteString)")
        initializeReader()
    }
    
    // MARK: - Private Methods
    
    private func initializeReader() {
        DispatchQueue.main.async { self.activityIndicator.startAnimating() }
        guard let dataPath = Bundle.main.path(forResource: "regula.license", ofType: nil) else {
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                self.showErrorAlert(title: "Initialization Error", message: "License file not found")
            }
            return
        }
        guard let licenseData = try? Data(contentsOf: URL(fileURLWithPath: dataPath)) else {
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                self.showErrorAlert(title: "Initialization Error", message: "Could not read license data")
            }
            return
        }
        
        let config = DocReader.Config(license: licenseData)
        DocReader.shared.initializeReader(config: config) { [weak self] (success, error) in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                
                if success {
                    guard let url = self.configURL else {
                        return self.showErrorAlert(title: "Configuration Error", message: "URL not available")
                    }
                    self.configureDocReaderSession(from: url)
                } else {
                    self.showErrorAlert(title: "Initialization Error", message: error?.localizedDescription ?? "Unknown initialization error")
                }
            }
        }
    }
    
    private func configureDocReaderSession(from url: URL) {
        print("Configuring DocReader from URL: \(url.absoluteString)")
        
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            print("Error: Could not parse URL components")
            showErrorAlert(title: "Configuration Error", message: "Could not parse URL")
            return
        }
        
        if "\(components.scheme ?? "https")://\(components.host ?? "")" == "https://example.com",
           components.queryItems?.isEmpty ?? true {
            print("App Clip launched without QR code scan (default example.com URL)")
            showErrorAlert(
                title: "QR Code Required",
                message: "The App Clip is cached on the phone. Please open the website https://api.regulaforensics.com on your computer and scan the QR code to start document scanning."
            )
            return
        }
        
        guard let queryItems = components.queryItems, !queryItems.isEmpty else {
            print("Error: URL does not contain query parameters")
            showErrorAlert(title: "Configuration Error", message: "URL does not contain query parameters")
            return
        }
        
        let tag = queryItems.first(where: { $0.name == "tag" })?.value
        tag.map {
            DocReader.shared.tag = $0
            print("Found tag in URL: \($0)")
        } ?? print("Warning: No tag found in URL")
        
        // Parse ComponentSettings to extract scenario
        if let componentSettingsString = queryItems.first(where: { $0.name == "ComponentSettings" })?.value,
           let decodedString = componentSettingsString.removingPercentEncoding,
           let jsonData = decodedString.data(using: .utf8),
           let jsonObject = try? JSONSerialization.jsonObject(with: jsonData) as? [String: Any],
           let scenarioString = jsonObject?["scenario"] as? String {
            print("Found scenario in ComponentSettings: \(scenarioString)")
            selectedScenario = scenarioString
            print("Mapped to scenario constant: \(selectedScenario)")
        } else {
            print("No scenario found in ComponentSettings, using default: \(selectedScenario)")
        }
        
        let backendProcessingConfig = RGLBackendProcessingConfig()
        backendProcessingConfig.url = "\(components.scheme ?? "https")://\(components.host ?? "")"
        backendProcessingConfig.rfidServerSideChipVerification = chipVerificationBool as NSNumber
        DocReader.shared.processParams.backendProcessingConfig = backendProcessingConfig
        DocReader.shared.processParams.multipageProcessing = true
        startDocumentScanning()
    }
    
    private func startDocumentScanning() {
        DocReader.shared.startScanner(presenter: self, config: DocReader.ScannerConfig(scenario: selectedScenario)) { [weak self] (action, result, error) in
            guard let self = self else { return }
            switch action {
            case .complete:
                result?.chipPage != 0 ? self.startRFIDReading() : self.finalize(result: result)
                
            case .processTimeout:
                let timeoutLabel = UILabel(frame: self.view.bounds)
                timeoutLabel.text = "Timeout!"
                timeoutLabel.font = .systemFont(ofSize: 22, weight: .medium)
                timeoutLabel.textAlignment = .center
                self.view.addSubview(timeoutLabel)
                UIView.animate(withDuration: 2, animations: { timeoutLabel.alpha = 0 }) { _ in timeoutLabel.removeFromSuperview() }
                
            case .error:
                error.map { self.showErrorAlert(title: "Scanning Error", message: $0.localizedDescription) }
            case .process:
                result.map { print("Scanning in progress. Result: \($0)") }
            default:
                result.map { print("Results: \($0), action: \(action)") }
            }
        }
    }
    
    private func startRFIDReading() {
        DocReader.shared.startRFIDReader(fromPresenter: self, completion: { [weak self] (action, results, error) in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch action {
                case .complete:
                    self.finalize(result: results)
                case .cancel:
                    print("RFID reading canceled")
                case .error:
                    self.showErrorAlert(title: "RFID Reading Error", message: error?.localizedDescription ?? "Unknown RFID reading error")
                default:
                    break
                }
            }
        })
    }
    
    private func finalize(result: DocumentReaderResults?) {
        activityIndicator.startAnimating()
        
        DocReader.shared.finalizePackage { [weak self] action, transactionInfo, error in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                
                if let error = error {
                    self.showErrorAlert(title: "Finalization Error", message: error.localizedDescription)
                } else if action == .complete {
                    transactionInfo?.transactionId.map { print("Finalize Done. TransactionId: \($0)") }
                    self.handleResult(result: result)
                }
            }
        }
    }
    
    private func handleResult(result: DocumentReaderResults?) {
        let alert = UIAlertController(title: "Success", message: "Return to the computer", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Close", style: .default))
        present(alert, animated: false)
    }
    
    private func showErrorAlert(title: String, message: String) {
        currentAlert?.dismiss(animated: false)
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            self?.currentAlert = nil
            if self?.configURL != nil, self?.isInitializationStarted == false {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { self?.startInitializationIfNeeded() }
            }
        })
        currentAlert = alert
        present(alert, animated: true)
    }
}
