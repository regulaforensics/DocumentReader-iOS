//
//  MainViewController.swift
//  DocumentReaderFullSwift-sample
//
//  Created by Sergey Yakimchik on 2/23/20.
//  Copyright © 2020 Dmitry Smolyakov. All rights reserved.
//

import UIKit
import DocumentReader

class MainViewController: UITableViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "customRfid" {
            let vc = segue.destination as! DefaultModeViewController
            vc.customRfid = true
        }
    }
}
