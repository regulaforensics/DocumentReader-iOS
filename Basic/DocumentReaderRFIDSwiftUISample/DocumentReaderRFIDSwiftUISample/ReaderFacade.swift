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

enum ReaderState {
  case notInitialized
  case initializing
  case ready
  case initError(String)
  case error(String)
}

class ReaderFacade: ObservableObject {

  @Published
  var state: ReaderState = .notInitialized

  @Published
  private var isInitialized: Bool = false

  @Published
  private var isProcessing: Bool = false

  @Published
  var areResultsReady: Bool = false

  @Published
  private var lastResults: DocumentReaderResults?

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
      state = .initError("License issue")
      return
    }
    state = .initializing

    let config = DocReader.Config(license: data)
    DocReader.shared.initializeReader(config: config)
      .sink(receiveCompletion: { completion in
        switch completion {
        case .finished:
          self.state = .ready
        case .failure(let error):
          self.state = .initError(error.localizedDescription)
        }
      }, receiveValue: { success in
        self.isInitialized = success
      }).store(in: &cancellables)


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
        switch completion {
        case .finished:
          self.state = .ready
        case .failure(let error):
          self.state = .error(error.localizedDescription)
        }
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
      controller = DocReader.shared.prepareCameraViewControllerForStart { action, result, error in
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
    let presenter = UIApplication.shared.firstKeyWindow!.rootViewController!
    return DocReader.shared.readRFIDController(presenter: presenter)
  }
}


