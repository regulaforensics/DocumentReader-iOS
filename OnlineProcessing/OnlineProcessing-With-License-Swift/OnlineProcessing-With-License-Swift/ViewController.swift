//
//  ViewController.swift
//  OnlineProcessing-With-License-Swift
//
//  Created by Dmitry Evglevsky on 7.10.24.
//

import UIKit
import DocumentReader

class ViewController: UIViewController {
    
    lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.translatesAutoresizingMaskIntoConstraints = false
        if #available(iOS 13.0, *) {
            indicator.style = .large
        }
        indicator.hidesWhenStopped = true
        
        return indicator
    }()
    
    lazy var initializationLabel: UILabel = {
        let label = UILabel()
        label.text = "Initializating..."
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        return label
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Name:"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        return label
    }()
    
    lazy var surnameLabel: UILabel = {
        let label = UILabel()
        label.text = "Surname:"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        return label
    }()
    
    lazy var portraitImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    lazy var showScannerButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Show Scanner", for: .normal)
        button.addTarget(self, action: #selector(showScanner), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(self.activityIndicator)
        view.addSubview(self.initializationLabel)
        view.addSubview(self.nameLabel)
        view.addSubview(self.surnameLabel)
        view.addSubview(self.portraitImageView)
        view.addSubview(self.showScannerButton)
        
        initializeConstraints()
        initializationReader()
    }
    
    private func initializationReader() {
        guard let dataPath = Bundle.main.path(forResource: "regula.license", ofType: nil) else {
            return
        }
        guard let licenseData = try? Data(contentsOf: URL(fileURLWithPath: dataPath)) else {
            return
        }
        
        let config = DocReader.Config(license: licenseData)
        DocReader.shared.initializeReader(config: config) { (success, error) in
            DispatchQueue.main.async {
                if success {
                    self.activityIndicator.stopAnimating()
                    self.initializationLabel.isHidden = true
                    
                    if DocReader.shared.availableScenarios.isEmpty {
                        self.initializationLabel.text = "Available scenarios list is empty"
                        self.showScannerButton.isEnabled = false
                    }
                } else {
                    self.activityIndicator.stopAnimating()
                    self.initializationLabel.text = "Initialization error: \(error?.localizedDescription ?? "unknown")"
                    print(error?.localizedDescription ?? "unknown")
                }
            }
        }
    }
    
    @objc
    private func showScanner() {
        DocReader.shared.functionality.forcePagesCount = 2
        let onlineProcessingConfig = DocReader.OnlineProcessingConfig(mode: .auto)
        onlineProcessingConfig.serviceURL = "https://api.regulaforensics.com"
        onlineProcessingConfig.processParams?.scenario = RGL_SCENARIO_FULL_PROCESS

        let config = DocReader.ScannerConfig(scenario: RGL_SCENARIO_FULL_PROCESS, onlineProcessingConfig: onlineProcessingConfig)
        DocReader.shared.startScanner(presenter: self, config: config) { action, results, error in
            self.showResults(results: results)
        }
    }
    
    private func showResults(results: DocumentReaderResults?) {
        guard let results = results else {
            return
        }
        
        let name = results.getTextFieldByType(fieldType: .ft_Given_Names)?.value
        nameLabel.text = "Name: \(name ?? "")"
        
        let surname = results.getTextFieldByType(fieldType: .ft_Surname)?.value
        surnameLabel.text = "Surname: \(surname ?? "")"
        
        if let portraitImage = results.getGraphicFieldImageByType(fieldType: .gf_Portrait) {
            portraitImageView.image = portraitImage
        }
    }
    
    private func initializeConstraints() {
        NSLayoutConstraint.activate([
            activityIndicator.widthAnchor.constraint(equalToConstant: 40),
            activityIndicator.heightAnchor.constraint(equalToConstant: 40),
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
        
        NSLayoutConstraint.activate([
            initializationLabel.topAnchor.constraint(equalTo: activityIndicator.bottomAnchor, constant: 24),
            initializationLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 32),
            initializationLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -32)
        ])
        
        NSLayoutConstraint.activate([
            nameLabel.heightAnchor.constraint(equalToConstant: 24),
            nameLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 120),
            nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 60),
            nameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -60),
        ])
        
        NSLayoutConstraint.activate([
            surnameLabel.heightAnchor.constraint(equalToConstant: 24),
            surnameLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            surnameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 60),
            surnameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -60),
        ])
        
        NSLayoutConstraint.activate([
            portraitImageView.topAnchor.constraint(equalTo: surnameLabel.bottomAnchor, constant: 24),
            portraitImageView.bottomAnchor.constraint(equalTo: showScannerButton.topAnchor, constant: -24),
            portraitImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 60),
            portraitImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -60),
        ])
        
        NSLayoutConstraint.activate([
            showScannerButton.heightAnchor.constraint(equalToConstant: 50),
            showScannerButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -60),
            showScannerButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 60),
            showScannerButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -60),
        ])
    }
    
}

