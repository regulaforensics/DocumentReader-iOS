//
//  BarcodeListViewController.swift
//  DocumentReader-Swift
//
//  Created by Dmitry Evglevsky on 10.02.21.
//  Copyright © 2021 Regula. All rights reserved.
//

import UIKit
import DocumentReader

let kBarcodeListCellId = "BarcodeListCell"

class BarcodeListViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var allItems: [BarcodeType] = []
    var selectedItems: [BarcodeType] = []
    var completion: (([BarcodeType]?) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Do barcodes"
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        let result = (selectedItems.count > 0) ? selectedItems : nil
        completion?(result)
    }
}

extension BarcodeListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kBarcodeListCellId, for: indexPath)
        let item = allItems[indexPath.row]
        cell.textLabel?.text = item.stringValue
        let isSelected = selectedItems.contains(item)
        cell.accessoryType = isSelected ? .checkmark : .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = allItems[indexPath.row]
        if let index = selectedItems.firstIndex(of: item) {
            selectedItems.remove(at: index)
        } else {
            selectedItems.append(item)
        }
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
}
