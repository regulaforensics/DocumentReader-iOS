//
//  DocumentReaderService.swift
//  DocumentReader-Swift
//
//  Created by Pavel Kondrashkov on 03/12/2021.
//  Copyright © 2021 Regula. All rights reserved.
//

import DocumentReader

final class DocumentReaderService {
    enum State {
        case downloadingDatabase(progress: Double)
        case initializingAPI
        case completed
        case error(String)
    }

    static let shared = DocumentReaderService()
    private init() { }

    func deinitializeAPI() {
        DocReader.shared.deinitializeReader()
    }

    func initializeDatabaseAndAPI(progress: @escaping (State) -> Void) {
        guard let dataPath = Bundle.main.path(forResource: kRegulaLicenseFile, ofType: nil) else {
            progress(.error("Missing Licence File in Bundle"))
            return
        }
        guard let licenseData = try? Data(contentsOf: URL(fileURLWithPath: dataPath)) else {
            progress(.error("Missing Licence File in Bundle"))
            return
        }

        DispatchQueue.global().async {
            DocReader.shared.prepareDatabase(
                databaseID: kRegulaDatabaseId,
                progressHandler: { (inprogress) in
                    progress(.downloadingDatabase(progress: inprogress.fractionCompleted))
                },
                completion: { (success, error) in
                    if let error = error, !success {
                        progress(.error("Database error: \(error.localizedDescription)"))
                        return
                    }
                    let config = DocReader.Config(license: licenseData)
                    DocReader.shared.initializeReader(config: config, completion: { (success, error) in
                        DispatchQueue.main.async {
                            progress(.initializingAPI)
                            if success {
                                progress(.completed)
                            } else {
                                progress(.error("Initialization error: \(error?.localizedDescription ?? "nil")"))
                            }
                        }
                    })
                }
            )
        }
    }
}
