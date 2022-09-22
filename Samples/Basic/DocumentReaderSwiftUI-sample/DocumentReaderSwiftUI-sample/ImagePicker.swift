//
//  ImagePicker.swift
//  DocReader-SUI-Sample
//
//  Created by Serge Rylko on 15.09.22.
//

import Foundation
import Combine
import PhotosUI

class ImagePicker {
    
    unowned var delegate: PickerDelegate
    
    lazy var controller: PHPickerViewController = {
        var configuration = PHPickerConfiguration()
        configuration.filter = .images
        configuration.selectionLimit = 1
        
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = delegate
        
        return picker
    }()
    
    init(delegate: PickerDelegate) {
        self.delegate = delegate
    }
}

class PickerDelegate: PHPickerViewControllerDelegate {
    
    private unowned let imagePublisher: PassthroughSubject<UIImage, Never>
    private var cancellables = Set<AnyCancellable>()
    
    init(imagePublisher: PassthroughSubject<UIImage, Never>) {
        self.imagePublisher = imagePublisher
    }

    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        let dismiss = { picker.dismiss(animated: true) }
        guard
            let provider = results.first?.itemProvider,
            provider.canLoadObject(ofClass: UIImage.self)
        else { dismiss(); return }
        
        provider
            .loadObject(ofClass: UIImage.self)
            .receive(on: DispatchQueue.main)
            .sink { finish in
                switch finish {
                case .failure(let error):
                    print(error.localizedDescription)
                case .finished: break
                }
                dismiss()
            } receiveValue: { [unowned self] item in
                if let image = item as? UIImage {
                    self.imagePublisher.send(image)
                }
            }.store(in: &cancellables)
    }
}

extension NSItemProvider {
    
    func loadObject(ofClass: NSItemProviderReading.Type) -> AnyPublisher<NSItemProviderReading, Error> {
        let future = Future<NSItemProviderReading, Error> { promise in
            self.loadObject(ofClass: ofClass) { object, error in
                if let error = error {
                    promise(.failure(error))
                } else if let object = object {
                    promise(.success(object))
                }
            }
        }
        return future.eraseToAnyPublisher()
    }
}
