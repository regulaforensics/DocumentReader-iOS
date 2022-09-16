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
    var dataBasePrepared: Bool = false
    
    @Published
    var downloadProgress: Int = 0
    
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
   
    func start() {
        guard
            let dataPath = Bundle.main.path(forResource: "regula.license", ofType: nil),
            let data = try? Data(contentsOf: URL(fileURLWithPath: dataPath))
        else {
            return
        }
        
        let config = DocReader.Config(license: data)
        
        DocReader.shared
            .prepareDatabase()
            .sink { [unowned self] completion in
                switch completion {
                case .finished:
                    self.dataBasePrepared = true
                case .failure(let error):
                    print(error.localizedDescription)
                }
            } receiveValue: { [unowned self] progress in
                self.downloadProgress = Int(progress * 100)
            }.store(in: &cancellables)
        
        $dataBasePrepared
            .filter { $0 == true }
            .flatMap { _ in DocReader.shared.initializeReader(config: config) }
            .replaceError(with: false)
            .assign(to: &$isInitialized)
        
        DocReader.shared.functionality.captureMode = .auto
        DocReader.shared.functionality.showCaptureButton = true
        
        $lastResults
            .map { $0?.textResult }
            .compactMap { $0?.fields }
            .assign(to: &$lastTextResultFields)
        
        $lastResults
            .map({ $0?.graphicResult })
            .compactMap { $0?.fields }
            .assign(to: &$lastGraphicResultFields)
 
        $isInitialized
            .filter({ $0 == true && self.selectedScenario.isEmpty})
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
        var configuration = PHPickerConfiguration()
        configuration.filter = .images
        configuration.selectionLimit = 1
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        return picker
    }
    
    private func prepareCameraController() -> (controller: UIViewController, results: AnyPublisher<DocumentReaderResults, Error>) {
        var controller: UIViewController?
        let future = Future<(DocumentReaderResults), Error> { promise in

            controller = DocReader.shared.prepareCameraViewController { action, result, error in
                switch action {
                case .complete:
                    promise(.success(result!))
                    controller?.dismiss(animated: true)
                case .error:
                    promise(.failure(error!))
                default:
                    break
                }
            }

        }.eraseToAnyPublisher()
        
        return (controller!, future)
    }
    
    private func recognizeImage(image: UIImage) {
        let future = Future<(DocumentReaderResults), Error> { promise in
            
            DocReader.shared.recognizeImage(image) { action, result, error in
                switch action {
                case .complete:
                    promise(.success(result!))
                case .error:
                    promise(.failure(error!))
                default:
                    break
                }
            }
            
        }.eraseToAnyPublisher()
        
        future.sink { _ in
        } receiveValue: { [unowned self] results in
            self.lastResults = results
        }.store(in: &cancellables)
    }
    
    func process(_ image: UIImage) -> Future<UIImage, Error> {
        Future { promise in
            //process(image, then: promise)
        }
    }
}

extension ReaderFacade: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        DispatchQueue.global().async {
            let imageItems = results
                .map { $0.itemProvider }
                .filter { $0.canLoadObject(ofClass: UIImage.self) }
            
            let group = DispatchGroup()
            var images = [UIImage]()
            
            for imageItem in imageItems {
                group.enter()
                imageItem.loadObject(ofClass: UIImage.self) { image, _ in
                    if let image = image as? UIImage {
                        images.append(image)
                    }
                    group.leave()
                }
            }
            
            group.notify(queue: .main) {
                guard let image = images.first else {
                    return
                }
                self.recognizeImage(image: image)
            }
        }
    }
}

extension DocReader {
    
    func initializeReader(config: DocReader.Config) -> AnyPublisher<Bool, Error> {
        Deferred {
            Future<Bool, Error> { promise in
                DocReader.shared.initializeReader(config: config) { success, error in
                    if let error = error {
                        promise(.failure(error))
                    } else {
                        if let firstScenario = DocReader.shared.availableScenarios.first {
                            DocReader.shared.processParams.scenario = firstScenario.identifier
                        }
                        promise(.success(success))
                    }
                }
            }
        }.eraseToAnyPublisher()
    }
    
    func prepareDatabase() -> AnyPublisher<Double, Error> {
        let subject = PassthroughSubject<Double, Error>()
        
        DocReader.shared.prepareDatabase(databaseID: "Full") { progress in
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
}
