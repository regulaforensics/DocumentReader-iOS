//
//  ViewController.swift
//  DocumentReaderCertificatePinning
//
//  Created by Serge Rylko on 11.10.23.
//

import UIKit
import DocumentReader

class ViewController: UIViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    prepareReader()
  }
  
  private func prepareReader() {
    guard let licenseData = licenseData() else {
      print("License file missed")
      return
    }
    let config = DocReader.Config(license: licenseData)
    DocReader.shared.initializeReader(config: config) { success, error in
      if success {
        print("DocumentReader initialized")
      } else {
        print("Initialization failed \(error!.localizedDescription)")
      }
    }
  }
  
  @IBAction func didPressRecognizeButton(_ sender: Any) {
    guard let image = UIImage(named: "mrz_sample.jpg") else { return }
    let config = DocReader.RecognizeConfig(image: image)
    config.onlineProcessingConfig = .init(mode: .auto)
    config.onlineProcessingConfig?.processParams?.scenario = RGL_SCENARIO_MRZ
    DocReader.shared.recognize(config: config) { action, results, error in
      switch action {
      case .complete:
        let name = results?.getTextFieldByType(fieldType: .ft_Surname_And_Given_Names)?.value ?? ""
        let mrzString = results?.getTextFieldByType(fieldType: .ft_MRZ_Strings)?.value ?? ""
        print("completed: \(name) \(mrzString)")
      case .cancel:
        print("cancel")
      case .error:
        print(error)
      case .processOnServer:
        print("process on server")
      default:
        print("default")
        print(action.rawValue)
      }
    }
  }
  
  private func licenseData() -> Data? {
    guard
      let url = Bundle.main.url(forResource: "regula", withExtension: "license"),
      let data = try? Data(contentsOf: url) else { return nil }
    return data
  }
}

