//
//  ReaderFacade.swift
//  DocReader-SUI-Sample
//
//  Created by Serge Rylko on 13.09.22.
//

import Foundation
import Combine
import DocumentReader
import UIKit
import PhotosUI

class ReaderFacade: ObservableObject {
    
    @Published
    var isInitialized: Bool = false
    
    @Published
    var isDatabasePrepared: Bool = false
    
    @Published
    var isProcessing: Bool = false
    
    @Published
    var downloadProgress: Int = 0
    
    @Published
    var areResultsReady: Bool = false

    @Published
    var lastResults: DocumentReaderResults?
    
    @Published
    var lastTextResultFields: [DocumentReaderTextField] = []
    
    @Published
    var lastGraphicResultFields: [DocumentReaderGraphicField] = []
    
    @Published
    var selectedScenario: String = ""
    
    @Published
    var availableScenarios: [String] = []

    private var cancellables: Set<AnyCancellable> = .init()
    
    init() {
        start()
    }
    
    private func start() {
        guard
            let dataPath = Bundle.main.path(forResource: "regula.license", ofType: nil),
            let data = try? Data(contentsOf: URL(fileURLWithPath: dataPath))
        else {
            return
        }
        
        let config = DocReader.Config(license: data)
        
        DocReader.shared
            .prepareDatabase(databaseID: "Full")
            .sink { [unowned self] completion in
                switch completion {
                case .finished:
                    self.isDatabasePrepared = true
                case .failure(let error):
                    print(error.localizedDescription)
                }
            } receiveValue: { [unowned self] progress in
                self.downloadProgress = Int(progress * 100)
            }.store(in: &cancellables)
        
        $isDatabasePrepared
            .filter { $0 == true }
            .flatMap { _ in DocReader.shared.initializeReader(config: config) }
            .replaceError(with: false)
            .assign(to: &$isInitialized)
        
        $lastResults
            .compactMap { $0?.textResult.fields }
            .assign(to: &$lastTextResultFields)
        
        $lastResults
            .compactMap { $0?.graphicResult.fields }
            .assign(to: &$lastGraphicResultFields)
        
        $lastResults
            .compactMap { $0 != nil }
            .assign(to: &$areResultsReady)
        
        $isInitialized
            .filter({ $0 == true && self.selectedScenario.isEmpty })
            .sink { [unowned self] _ in
                self.availableScenarios = DocReader.shared.availableScenarios.map { $0.identifier }
                self.selectedScenario = DocReader.shared.availableScenarios.first?.identifier ?? ""
            }.store(in: &cancellables)
        
        $selectedScenario
            .filter({ $0.isEmpty == false })
            .sink { scenario in
                DocReader.shared.processParams.scenario = scenario
            }.store(in: &cancellables)
    }
    
    func getCameraController() -> UIViewController {
        let prepared = prepareCameraController()

        prepared
            .results
            .delay(for: 0.25, scheduler: DispatchQueue.main) // dismiss RFID controller delay
            .flatMap(readRFIDIfNeeded(results:))
            .sink { completion in
                self.isProcessing = false
            } receiveValue: { results in
                self.lastResults = results
            }.store(in: &cancellables)

        return prepared.controller
    }

    private func prepareCameraController() -> (controller: UIViewController,
                                               results: AnyPublisher<DocumentReaderResults, Error>) {
        var controller: UIViewController?
        let dismiss = {
            DocReader.shared.stopScanner()
            controller?.dismiss(animated: true)
        }

        let future = Future<(DocumentReaderResults), Error> { promise in
            controller = DocReader.shared.prepareCameraViewController { action, result, error in
                switch action {
                case .complete:
                    promise(.success(result!))
                    dismiss()
                case .error:
                    promise(.failure(error!))
                    dismiss()
                case .processTimeout:
                    promise(.success(result!))
                    dismiss()
                default:
                    break
                }
            }
        }.eraseToAnyPublisher()
        
        return (controller ?? UIViewController(), future)
    }

    private func readRFIDIfNeeded(results: DocumentReaderResults) -> AnyPublisher<DocumentReaderResults, Error> {
        guard results.getTextFieldByType(fieldType: .ft_MRZ_Type) != nil else {
            return Just(results).setFailureType(to: Error.self).eraseToAnyPublisher()
        }
        isProcessing = true
        let presenter = UIApplication.shared.firstKeyWindow!.rootViewController!
        return DocReader.shared.readRFIDController(presenter: presenter)
    }
}


