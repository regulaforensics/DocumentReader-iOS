//
//  OnlineProcessingViewController.swift
//  DocumentReader-Swift
//
//  Created by Pavel Kondrashkov on 23/03/2022.
//  Copyright © 2022 Regula. All rights reserved.
//

import UIKit
import Photos
import DocumentReader

final class OnlineProcessingViewController: UIViewController {
    private let session: URLSession
    private var image: UIImage?

    private lazy var imageView: UIImageView = {
        let view = UIImageView()
        let tapGestureFirst = UITapGestureRecognizer(target: self, action: #selector(self.handleImageViewPress))
        view.addGestureRecognizer(tapGestureFirst)
        view.contentMode = .scaleAspectFit
        view.layer.cornerRadius = 8
        view.isUserInteractionEnabled = true
        view.backgroundColor = UIColor(red: 0.96, green: 0.96, blue: 0.96, alpha: 1.00)
        return view
    }()

    private lazy var textLabel: UILabel = {
        let label = UILabel()
        label.text = "Select Image"
        label.font = .preferredFont(forTextStyle: .body)
        return label
    }()

    private lazy var sendRequestButton: UIButton = {
        let button = UIButton(type: .system)
        button.addTarget(self, action: #selector(self.handleSendRequestButtonPress), for: .touchUpInside)
        button.setTitle("Send Request", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17)
        button.layer.cornerRadius = 8
        button.backgroundColor = UIColor(red: 0.10, green: 0.21, blue: 0.56, alpha: 1.00)
        button.contentEdgeInsets = UIEdgeInsets(top: 16, left: 0, bottom: 16, right: 0)
        button.layer.cornerRadius = 5
        button.clipsToBounds = false
        return button
    }()

    private lazy var clearButton: UIButton = {
        let button = UIButton(type: .system)
        button.addTarget(self, action: #selector(self.handleClearButtonPress), for: .touchUpInside)
        button.setTitle("Clear", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17)
        button.layer.cornerRadius = 8
        button.backgroundColor = UIColor(red: 0.10, green: 0.21, blue: 0.56, alpha: 1.00)
        button.contentEdgeInsets = UIEdgeInsets(top: 16, left: 0, bottom: 16, right: 0)
        button.layer.cornerRadius = 5
        button.clipsToBounds = false
        return button
    }()

    lazy var loaderView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .gray)
        view.hidesWhenStopped = true
        view.backgroundColor = UIColor(red: 0.96, green: 0.96, blue: 0.96, alpha: 1.00)
        view.layer.cornerRadius = 8
        return view
    }()

    override func loadView() {
        view = UIView()

        let root = UIStackView()
        root.spacing = 25
        root.axis = .vertical

        view.addSubview(root)
        root.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            root.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            root.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            root.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            root.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40),
        ])

        let imagesContainer = UIStackView()
        imagesContainer.axis = .vertical
        imagesContainer.distribution = .fillEqually
        imagesContainer.spacing = 45
        imagesContainer.addArrangedSubview(imageView)

        imageView.addSubview(textLabel)
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            textLabel.centerXAnchor.constraint(equalTo: imageView.centerXAnchor),
            textLabel.centerYAnchor.constraint(equalTo: imageView.centerYAnchor)
        ])

        imagesContainer.addArrangedSubview(imageView)
        root.addArrangedSubview(imagesContainer)
        root.addArrangedSubview(sendRequestButton)
        root.addArrangedSubview(clearButton)

        view.addSubview(loaderView)
        loaderView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            loaderView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loaderView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }

    init() {
        self.session = URLSession(configuration: URLSessionConfiguration.default)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "close-icon"), style: .plain, target: self, action: #selector(self.handleCloseButtonPress))
        if #available(iOS 13.0, *) {
            view.backgroundColor = .systemBackground
        } else {
            view.backgroundColor = .white
        }
    }

    @objc func handleCloseButtonPress() {
        self.dismiss(animated: true, completion: nil)
    }

    @objc private func handleClearButtonPress(sender: UIButton) {
        self.imageView.image = nil
        self.image = nil
        self.textLabel.text = "Select Image"
    }

    @objc private func handleSendRequestButtonPress() {
        guard let image = image else {
            let alert = UIAlertController(title: "Plase select an image first.", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }

        // For more information please visit
        // https://github.com/regulaforensics/DocumentReader-web-openapi/blob/master/p-process.yml
        guard let imageData = image.pngData()?.base64EncodedString() else {
            let alert = UIAlertController(title: "Plase select a valid image.", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }

        let requestImage: [String: Any] = [
            "ImageData": ["image": imageData],
            "light": 6,
            "page_idx": 0
        ]
        let jsonContent: [String: Any] = [
            "processParam": [
                "scenario": "FullProcess",
                "doublePageSpread": true,
                "measureSystem": 0, // Metric system of measurement.
                "dateFormat": "M/d/yyyy",
                "alreadyCropped": true
            ],
            "List": [
                requestImage
            ]
        ]

        var request = URLRequest(url: URL(string: "https://api.regulaforensics.com/api/process")!)
        request.httpMethod = "POST"
        request.httpBody = try? JSONSerialization.data(withJSONObject: jsonContent, options: [])
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        self.view.isUserInteractionEnabled = false
        self.loaderView.startAnimating()
        session.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                self.view.isUserInteractionEnabled = true
                self.loaderView.stopAnimating()

                if let error = error {
                    let alert = UIAlertController(title: error.localizedDescription, message: nil, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    return
                }

                guard
                    let data = data,
                    let _ = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                    let rawJSON = String(data: data, encoding: .utf8)
                else {
                    if let data = data {
                        print("Received invalid data: \(String(data: data, encoding: .utf8)!)")
                    }

                    let alert = UIAlertController(title: "Failed to parse JSON.", message: nil, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    return
                }

                let results = DocumentReaderResults(rawJSON: rawJSON)
                self.presentResults(results)
            }
        }.resume()
    }

    @objc private func handleImageViewPress() {
        let alert = createAlertImagePicker(completion: { [weak self] (image) in
            if let image = image {
                self?.textLabel.text = nil
                self?.imageView.image = image
                self?.image = image
            }
        })

        if let popoverPresentationController = alert.popoverPresentationController {
            popoverPresentationController.sourceView = view
            popoverPresentationController.sourceRect = CGRect(
                x: imageView.frame.midX,
                y: imageView.frame.midY,
                width: 0,
                height: 0
            )
        }
        self.present(alert, animated: true, completion: nil)
    }

    private func createAlertImagePicker(completion: @escaping (UIImage?) -> Void) -> UIAlertController {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
            self.pickImage(sourceType: .photoLibrary) { image in
                completion(image)
            }
        }))
        alert.addAction(UIAlertAction(title: "Camera Shoot", style: .default, handler: { _ in
            self.pickImage(sourceType: .camera) { image in
                completion(image)
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
            completion(nil)
        }))

        return alert
    }

    private var imagePickerCompletion: ((UIImage?) -> Void)?

    private func pickImage(sourceType: UIImagePickerController.SourceType, completion: @escaping ((UIImage?) -> Void)) {
        PHPhotoLibrary.requestAuthorization { (status) in
            DispatchQueue.main.async {
                switch status {
                case .authorized:
                    if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) {
                        self.imagePickerCompletion = completion
                        let imagePicker = UIImagePickerController()
                        imagePicker.delegate = self
                        imagePicker.sourceType = sourceType
                        imagePicker.allowsEditing = false
                        imagePicker.navigationBar.tintColor = .black
                        self.present(imagePicker, animated: true, completion: nil)

                    } else {
                        completion(nil)
                    }
                case .denied:
                    let message = NSLocalizedString("Application doesn't have permission to use the camera, please change privacy settings", comment: "Alert message when the user has denied access to the gallery")
                    let alertController = UIAlertController(title: NSLocalizedString("Gallery Unavailable", comment: "Alert eror title"), message: message, preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Alert manager, OK button tittle"), style: .cancel, handler: nil))
                    alertController.addAction(UIAlertAction(title: NSLocalizedString("Settings", comment: "Alert button to open Settings"), style: .default, handler: { action in
                        guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else { return }
                        if #available(iOS 10.0, *) {
                            UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
                        } else {
                            UIApplication.shared.openURL(settingsURL)
                        }
                    }))
                    self.present(alertController, animated: true, completion: nil)
                    print("PHPhotoLibrary status: denied")
                    completion(nil)
                case .notDetermined:
                    print("PHPhotoLibrary status: notDetermined")
                    completion(nil)
                case .restricted:
                    print("PHPhotoLibrary status: restricted")
                    completion(nil)
                case .limited:
                    print("PHPhotoLibrary status: Limited")
                    completion(nil)
                @unknown default:
                    fatalError()
                }
            }
        }
    }

    private func presentResults(_ results: DocumentReaderResults) {
        let mainStoryboard = UIStoryboard(name: kMainStoryboardId, bundle: nil)
        guard let resultsViewController = mainStoryboard.instantiateViewController(withIdentifier: kResultsViewControllerId) as? ResultsViewController else {
            return
        }
        resultsViewController.results = results
        navigationController?.pushViewController(resultsViewController, animated: true)
    }
}


extension OnlineProcessingViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let image = info[.originalImage] as? UIImage {
            picker.dismiss(animated: true, completion: {
                self.imagePickerCompletion?(image)
            })
        } else {
            picker.dismiss(animated: true, completion: {
                self.imagePickerCompletion?(nil)
            })
            print("Something went wrong")
        }
    }
}
