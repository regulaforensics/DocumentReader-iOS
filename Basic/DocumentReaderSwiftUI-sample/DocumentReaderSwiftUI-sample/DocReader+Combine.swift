//
//  DocReader+Combine.swift
//  DocReader-SUI-Sample
//
//  Created by Deposhe on 14.09.22.
//

import Foundation
import Combine
import DocumentReader

extension DocReader {
    
    func initializeReader(config: DocReader.Config) -> AnyPublisher<Bool, Error> {
            Future<Bool, Error> { promise in
                DocReader.shared.initializeReader(config: config) { success, error in
                    if let error = error {
                        promise(.failure(error))
                    } else {
                        promise(.success(success))
                    }
                }
        }.eraseToAnyPublisher()
    }
    
    func recognize(config: DocReader.RecognizeConfig) -> AnyPublisher<DocumentReaderResults, Error> {
        Deferred {
            Future<DocumentReaderResults, Error> { promise in
                DocReader.shared.recognize(config: config) { _, results, error in
                    if let error = error {
                        promise(.failure(error))
                    } else if let results = results {
                        promise(.success(results))
                    }
                }
            }
        }.eraseToAnyPublisher()
    }
}
