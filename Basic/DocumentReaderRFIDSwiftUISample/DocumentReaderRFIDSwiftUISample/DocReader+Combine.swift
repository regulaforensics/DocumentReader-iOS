//
//  DocReader+Combine.swift
//  DocReader-SUI-Sample
//
//  Created by Deposhe on 14.09.22.
//

import Foundation
import Combine
import DocumentReader

enum RFIDError: Error {
    case cancel
    case timeout
}

extension DocReader {

    func prepareDatabase(databaseID: String) -> AnyPublisher<Double, Error> {
        let subject = PassthroughSubject<Double, Error>()

        DocReader.shared.prepareDatabase(databaseID: databaseID) { progress in
            subject.send(progress.fractionCompleted)
        } completion: { success, error in
            if let error = error {
                subject.send(completion: .failure(error))
            } else {
                subject.send(completion: .finished)
            }
        }
        return subject.eraseToAnyPublisher()
    }

    func initializeReader(config: DocReader.Config) -> AnyPublisher<Bool, Error> {
        Deferred {
            Future<Bool, Error> { promise in
                DocReader.shared.initializeReader(config: config) { success, error in
                    if let error = error {
                        promise(.failure(error))
                    } else {
                        promise(.success(success))
                    }
                }
            }
        }.eraseToAnyPublisher()
    }

    // Read RFID without ReaderUI
    func readRFID() -> AnyPublisher<DocumentReaderResults, Error> {
        Deferred {
            Future<DocumentReaderResults, Error> { promise in
                DocReader.shared.readRFID(nil) { action, results, error, codes in
                    if let error = error {
                        promise(.failure(error))
                    } else if let results = results {
                        promise(.success(results))
                    }
                }
            }
        }.eraseToAnyPublisher()
    }

    // Read RFID with ReaderUI
    func readRFIDController(presenter: UIViewController) -> AnyPublisher<DocumentReaderResults, Error> {
        Deferred {
            Future<DocumentReaderResults, Error> { promise in
                DocReader.shared.startRFIDReader(fromPresenter: presenter) { action, results, error in
                    if let error = error {
                        promise(.failure(error))
                    } else if let results = results {
                        promise(.success(results))
                    } else if action == .cancel {
                        promise(.failure(RFIDError.cancel))
                    } else if action == .processTimeout {
                        promise(.failure(RFIDError.timeout))
                    }
                }
            }
        }.eraseToAnyPublisher()
    }
}
