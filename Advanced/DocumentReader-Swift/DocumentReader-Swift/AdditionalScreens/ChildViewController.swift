//
//  ChildViewController.swift
//  DocumentReader-Swift
//
//  Created by Dmitry Evglevsky on 11.02.21.
//  Copyright © 2021 Regula. All rights reserved.
//

import UIKit
import DocumentReader

class ChildViewController: UIViewController {
    
    var completionHandler: DocumentReaderResultsClosure? = nil
    var scenario: String?
    private var cameraViewController: UIViewController? = nil
    private var latestDocumentReaderResults: DocumentReaderResults?
    
    @IBOutlet weak var presenterView: UIView!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var showResultsButton: UIButton!
    @IBOutlet weak var messageLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenterView.layer.borderWidth = 1
        self.showResultsButton.isEnabled = false
        self.messageLabel.text = ""
    }
    
    @IBAction func startAction(_ sender: UIButton) {
        startScanner()
        startButton.isEnabled = false
        self.messageLabel.text = ""
    }
    
    @IBAction func showResults(_ sender: Any) {
        self.navigationController?.popViewController(animated: false)
        if let results = self.latestDocumentReaderResults {
            self.completionHandler?(results)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        cameraViewController?.view.frame = presenterView.frame
    }
    
    private func startScanner() {
        DocReader.shared.startNewSession()
        DocReader.shared.isCameraSessionIsPaused = false

        DocReader.shared.processParams.scenario = scenario
        DocReader.shared.functionality.orientation = .all
        
        let vc = DocReader.shared.prepareCameraViewControllerForStart(cameraHandler: { [weak self] (action, results, error) in
            guard let self = self else { return }
            switch action {
            case .complete, .processTimeout:
                DocReader.shared.isCameraSessionIsPaused = true
                self.latestDocumentReaderResults = results
                
                startButton.isEnabled = true
                self.showResultsButton.isEnabled = true
                self.messageLabel.text = "RECOGNITION COMPLETED"
            case .morePagesAvailable:
                break
            case .cancel:
                self.stopScan()
            case .error:
                break
            case .process:
                // you can handle intermediate result here
                break
            case .processWhiteFlashLight, .processOnServer:
                break;
            @unknown default:
                break
            }
        })
        cameraViewController = vc
        
        addChild(cameraViewController!)
        cameraViewController?.view.frame = self.presenterView.frame
        view.addSubview(cameraViewController!.view)
        cameraViewController!.didMove(toParent: self)
    }
    
    func stopScan() {
        cameraViewController?.willMove(toParent: nil)
        cameraViewController?.view.removeFromSuperview()
        cameraViewController?.removeFromParent()
        cameraViewController = nil
        startButton.isEnabled = true
    }
}
