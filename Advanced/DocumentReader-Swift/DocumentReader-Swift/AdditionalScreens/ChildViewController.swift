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
    
    @IBOutlet weak var presenterView: UIView!
    @IBOutlet weak var startButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenterView.layer.borderWidth = 1
    }
    
    @IBAction func startAction(_ sender: UIButton) {
        startScanner()
        startButton.isEnabled = false
    }
  
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        cameraViewController?.view.frame = presenterView.frame
    }
    
    private func startScanner() {
        DocReader.shared.processParams.scenario = scenario
        DocReader.shared.functionality.orientation = .all
        let vc = DocReader.shared.prepareCameraViewController(cameraHandler: { [weak self] (action, results, error) in
            guard let self = self else { return }
            switch action {
            case .complete:
                DocReader.shared.isCameraSessionIsPaused = true
                self.navigationController?.popViewController(animated: false)
                if let results = results {
                    self.completionHandler?(results)
                }
            case .morePagesAvailable:
                break
            case .cancel:
                self.stopScan()
            case .error:
                break
            case .process:
                // you can handle intermediate result here
                break
            case .processWhiteFlashLight:
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
