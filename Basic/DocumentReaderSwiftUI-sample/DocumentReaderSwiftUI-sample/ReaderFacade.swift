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
    
    private var picker: ImagePicker?
    private var pickerDelegate: PickerDelegate?
   
    private var cancellables: Set<AnyCancellable> = .init()
    
    init() {
        start()
    }
    
    func start() {
        guard
            let dataPath = Bundle.main.path(forResource: "regula.license", ofType: nil),
            let data = try? Data(contentsOf: URL(fileURLWithPath: dataPath))
        else {
            return
        }
        
        let config = DocReader.Config(license: data)

        DocReader.shared.initializeReader(config: config)
            .replaceError(with: false)
            .assign(to: &$isInitialized)
        
        DocReader.shared.functionality.captureMode = .auto
        DocReader.shared.functionality.showCaptureButton = true
        
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
        prepared.results
            .sink { _ in
            } receiveValue: { [unowned self] results in
                self.lastResults = results
            }.store(in: &cancellables)
        return prepared.controller
    }
    
    func getGalleryController() -> UIViewController {
        let prepared = preparePickerController()
        prepared.results
            .sink { _ in
            } receiveValue: { [unowned self] results in
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
                    print("Timeout reached")
                    promise(.success(result!))
                    dismiss()
                default:
                    break
                }
            }
            
        }.eraseToAnyPublisher()
        
        return (controller ?? UIViewController(), future)
    }

    private func preparePickerController() -> (controller: UIViewController,
                                               results: AnyPublisher<DocumentReaderResults, Error>) {
        let pickerImage = PassthroughSubject<UIImage, Never>()
        let results = pickerImage
            .flatMap { self.recognize(image: $0) }
            .eraseToAnyPublisher()
        
        let pickerDelegate = PickerDelegate(imagePublisher: pickerImage)
        let picker = ImagePicker(delegate: pickerDelegate)
        self.picker = picker
        self.pickerDelegate = pickerDelegate
        
        return (picker.controller, results)
    }
    
    private func recognize(image: UIImage) -> AnyPublisher<DocumentReaderResults, Error> {
        isProcessing = true
        let config = DocReader.RecognizeConfig(scenario: selectedScenario)
        config.image = image
        
        let recognize = DocReader.shared
            .recognize(config: config)
            .mapError { error in
                self.isProcessing = false
                return error
            }
            .map {
                self.isProcessing = false
                return $0
            }
            .eraseToAnyPublisher()

        return recognize
    }
}
