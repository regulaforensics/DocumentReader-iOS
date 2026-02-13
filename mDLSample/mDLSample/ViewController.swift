//
//  ViewController.swift
//  mDLSample
//
//  Created by Dmitry Evglevsky on 15.12.25.
//  Copyright © 2025 Regula. All rights reserved.
//

import UIKit
import DocumentReader

struct ValueItem {
    var text: String? = nil
    var image: UIImage? = nil
}

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let kTextCellId = "TextTableViewCell"
    let kImageCellId = "ImageTableViewCell"
    
    var results: DocumentReaderResults? = nil
    var items: [ValueItem] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeDocumentReader()
        setupUI()
    }
    
    func setupUI() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        tableView.register(UINib(nibName: kTextCellId, bundle: nil), forCellReuseIdentifier: kTextCellId)
        tableView.register(UINib(nibName: kImageCellId, bundle: nil), forCellReuseIdentifier: kImageCellId)
        tableView.showsVerticalScrollIndicator = true
    }
    
    func initializeDocumentReader() {
        guard let dataPath = Bundle.main.path(forResource: "regula.license", ofType: nil) else {
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
                    print("DocumentReader Initialized")
                } else {
                    print("Initialization error: \(error?.localizedDescription ?? "nil")")
                }
            }
        })
    }
    
    func reloadUI() {
        self.items.removeAll()
        
        for imageValue in results?.graphicResult.fields ?? [] {
            var item = ValueItem()
            item.image = imageValue.value
            items.append(item)
        }
        
        for textValue in results?.textResult.fields ?? [] {
            var item = ValueItem()
            item.text = "\(textValue.fieldName): \(textValue.value)"
            items.append(item)
        }
        
        self.tableView.reloadData()
    }
    
    func startMDLReader(_ dataRetrieval: DocReader.DataRetrieval) {
        DocReader.shared.startEngageDevice(fromPresenter: self, type: .QR) { engagement, error  in

            guard let engagement = engagement else {
              return
            }
            
            DocReader.shared.startRetrieveData(engagement, dataRetrieval: dataRetrieval) { action, results, error in
                if let error = error {
                    print(error)
                    return
                }
                
                guard let results else {
                    return
                }
                self.results = results
                self.reloadUI()
            }
        }
    }

    @IBAction func agePressed(_ sender: Any) {
        let dataRetrieval = DocReader.DataRetrieval.init(deviceRetrieval: .BLE)
        dataRetrieval.setDocRequestPreset(.age, intentToRetain: .true)
        startMDLReader(dataRetrieval)
    }
    
    @IBAction func standartIdPressed(_ sender: Any) {
        let dataRetrieval = DocReader.DataRetrieval.init(deviceRetrieval: .BLE)
        dataRetrieval.setDocRequestPreset(.srandardID, intentToRetain: .true)
        startMDLReader(dataRetrieval)
    }
    
    @IBAction func travelPressed(_ sender: Any) {
        let dataRetrieval = DocReader.DataRetrieval.init(deviceRetrieval: .BLE)
        dataRetrieval.setDocRequestPreset(.travel, intentToRetain: .true)
        startMDLReader(dataRetrieval)
    }
    
    @IBAction func driversLicensePressed(_ sender: Any) {
        let dataRetrieval = DocReader.DataRetrieval.init(deviceRetrieval: .BLE)
        dataRetrieval.setDocRequestPreset(.driversLicense, intentToRetain: .true)
        startMDLReader(dataRetrieval)
    }
    
    @IBAction func readAllBlePressed(_ sender: Any) {
        let docRequest = DocReader.DocumentRequest18013MDL.init()
        docRequest.enableIntentToRetainValues()
        let dataRetrieval = DocReader.DataRetrieval.init(deviceRetrieval: .BLE)
        dataRetrieval.requests = [docRequest]
        startMDLReader(dataRetrieval)
    }
    
    @IBAction func readAllNfcPressed(_ sender: Any) {
        let docRequest = DocReader.DocumentRequest18013MDL.init()
        docRequest.enableIntentToRetainValues()
        let dataRetrieval = DocReader.DataRetrieval.init(deviceRetrieval: .NFC)
        dataRetrieval.requests = [docRequest]
        
        DocReader.shared.startReadMDL(fromPresenter: self, engagementType: .NFC, dataRetrieval: dataRetrieval) { action, results, error in
            if let error = error {
                print(error)
                return
            }
            guard let results else {
                return
            }
            self.results = results
            self.reloadUI()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = items[indexPath.row]
        
        if (item.image != nil) {
            let cell = tableView.dequeueReusableCell(withIdentifier: kImageCellId,
                                                     for: indexPath) as! ImageTableViewCell
            cell.graphicResultImageView.image = item.image
            return cell
        } else if item.text != nil {
            let cell = tableView.dequeueReusableCell(withIdentifier: kTextCellId,
                                                     for: indexPath) as! TextTableViewCell
            cell.textValueLabel.text = item.text
            return cell
        }
        
        return UITableViewCell()
    }
    
}

