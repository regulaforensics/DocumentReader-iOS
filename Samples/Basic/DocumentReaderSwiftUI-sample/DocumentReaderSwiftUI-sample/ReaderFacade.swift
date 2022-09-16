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
    var downloadProgress: Double = 0.0
    
    @Published
    var lastResults: DocumentReaderResults?
    
    @Published
    var lastTextResultFields: [DocumentReaderTextField] = []
    
    @Published
    var lastGraphicResultFields: [DocumentReaderGraphicField] = []
    
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
        
        DocReader.shared.prepareDatabase()
            .replaceError(with: .completed(false))
            .sink { [unowned self] event in
                switch event {
                case .updated(let progress):
                    self.downloadProgress = progress
                case .completed(let value):
                    print("\(value)")
                }
            }
            .store(in: &cancellables)
        
        DocReader.shared.initializeReader(config: config)
            .replaceError(with: false)
            .eraseToAnyPublisher()
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
    
    enum PrepareEvent {
        case updated(progress: Double)
        case completed(Bool)
    }
    
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
    
    func prepareDatabase() -> AnyPublisher<PrepareEvent, Error> {
        let subject = PassthroughSubject<PrepareEvent, Error>()
        
        DocReader.shared.prepareDatabase(databaseID: "Full") { progress in
            subject.send(.updated(progress: progress.fractionCompleted))
        } completion: { success, error in
            if let error = error {
                subject.send(completion: .failure(error))
            } else {
                subject.send(.completed(true))
                subject.send(completion: .finished)
            }
        }
        
        return subject.eraseToAnyPublisher()
    }
}
