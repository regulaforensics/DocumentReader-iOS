import UIKit
import DocumentReader

class ViewController: UIViewController {

    // MARK: - Key Type

    private enum KeyType: Int, CaseIterable {
        case mrz = 0
        case can
        case pin
        case puk
        case pinEsign
        case sai
        case mrzHash

        var title: String {
            switch self {
            case .mrz: return "MRZ"
            case .can: return "CAN"
            case .pin: return "PIN"
            case .puk: return "PUK"
            case .pinEsign: return "ePIN"
            case .sai: return "SAI"
            case .mrzHash: return "Hash"
            }
        }

        var passwordType: RFIDPasswordType {
            switch self {
            case .mrz: return .mrz
            case .can: return .can
            case .pin: return .pin
            case .puk: return .puk
            case .pinEsign: return .pinEsign
            case .sai: return .sai
            case .mrzHash: return .mrzHash
            }
        }

        var passwordPlaceholder: String {
            switch self {
            case .mrz:
                return "Document data"
            case .can:
                return "CAN (6 digits)"
            case .pin:
                return "PIN (access code)"
            case .puk:
                return "PUK (unlock code)"
            case .pinEsign:
                return "eSign PIN"
            case .sai:
                return "SAI (Scanning Area Identifier)"
            case .mrzHash:
                return "MRZ hash"
            }
        }
    }

    // MARK: - UI

    private let activityIndicator = UIActivityIndicatorView(style: .large)
    private let statusLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 15)
        label.text = "Initializing Document Reader..."
        return label
    }()

    private let keyTypeSegment: UISegmentedControl = {
        let items = KeyType.allCases.map(\.title)
        let control = UISegmentedControl(items: items)
        control.selectedSegmentIndex = KeyType.mrz.rawValue
        return control
    }()

    private let mrzTextView: UITextView = {
        let textView = UITextView()
        textView.font = .monospacedSystemFont(ofSize: 15, weight: .regular)
        textView.autocorrectionType = .no
        textView.autocapitalizationType = .allCharacters
        textView.smartDashesType = .no
        textView.smartQuotesType = .no
        textView.smartInsertDeleteType = .no
        textView.backgroundColor = .secondarySystemBackground
        textView.layer.cornerRadius = 10
        textView.textContainerInset = UIEdgeInsets(top: 12, left: 10, bottom: 12, right: 10)
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()

    private let passwordField = makeTextField(placeholder: "CAN / PIN value")

    private lazy var mrzStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [mrzTextView])
        stack.axis = .vertical
        stack.spacing = 12
        return stack
    }()

    private lazy var passwordStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [passwordField])
        stack.axis = .vertical
        stack.spacing = 12
        stack.isHidden = true
        return stack
    }()

    private let startButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Start RFID Reading", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        button.isEnabled = false
        return button
    }()

    private let resultTextView: UITextView = {
        let textView = UITextView()
        textView.font = .monospacedSystemFont(ofSize: 13, weight: .regular)
        textView.textAlignment = .left
        textView.isEditable = false
        textView.isSelectable = true
        textView.isScrollEnabled = false
        textView.backgroundColor = .clear
        textView.textContainerInset = .zero
        textView.textContainer.lineFragmentPadding = 0
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()

    private let portraitImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .secondarySystemBackground
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 12
        imageView.isHidden = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let resultScrollView = UIScrollView()
    private lazy var resultContentStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [portraitImageView, resultTextView])
        stack.axis = .vertical
        stack.spacing = 16
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    // MARK: - State

    private var selectedKeyType: KeyType = .mrz
    private var passwordValues: [KeyType: String] = [:]

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "RFID Sample"
        view.backgroundColor = .systemBackground
        setupUI()
        initializeDocumentReader()
    }

    // MARK: - UI Setup

    private func setupUI() {
        let mainStack = UIStackView(arrangedSubviews: [
            keyTypeSegment,
            mrzStack,
            passwordStack,
            startButton,
        ])
        mainStack.axis = .vertical
        mainStack.spacing = 16
        mainStack.translatesAutoresizingMaskIntoConstraints = false

        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        resultScrollView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(activityIndicator)
        view.addSubview(statusLabel)
        view.addSubview(mainStack)
        view.addSubview(resultScrollView)
        resultScrollView.addSubview(resultContentStack)

        let guide = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: guide.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: guide.centerYAnchor),

            statusLabel.topAnchor.constraint(equalTo: activityIndicator.bottomAnchor, constant: 12),
            statusLabel.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: 20),
            statusLabel.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: -20),

            mainStack.topAnchor.constraint(equalTo: guide.topAnchor, constant: 20),
            mainStack.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: 20),
            mainStack.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: -20),

            resultScrollView.topAnchor.constraint(equalTo: mainStack.bottomAnchor, constant: 20),
            resultScrollView.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: 20),
            resultScrollView.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: -20),
            resultScrollView.bottomAnchor.constraint(equalTo: guide.bottomAnchor, constant: -10),

            resultContentStack.topAnchor.constraint(equalTo: resultScrollView.contentLayoutGuide.topAnchor),
            resultContentStack.leadingAnchor.constraint(equalTo: resultScrollView.contentLayoutGuide.leadingAnchor),
            resultContentStack.trailingAnchor.constraint(equalTo: resultScrollView.contentLayoutGuide.trailingAnchor),
            resultContentStack.bottomAnchor.constraint(equalTo: resultScrollView.contentLayoutGuide.bottomAnchor),
            resultContentStack.widthAnchor.constraint(equalTo: resultScrollView.frameLayoutGuide.widthAnchor),

            mrzTextView.heightAnchor.constraint(equalToConstant: 96),
            portraitImageView.heightAnchor.constraint(equalToConstant: 220),
        ])

        mainStack.isHidden = true
        activityIndicator.startAnimating()
        mrzTextView.delegate = self
        mrzTextView.text = "MRZ (paste full line or lines)"
        mrzTextView.textColor = .placeholderText

        keyTypeSegment.addTarget(self, action: #selector(keyTypeChanged), for: .valueChanged)
        passwordField.addTarget(self, action: #selector(passwordFieldChanged), for: .editingChanged)
        startButton.addTarget(self, action: #selector(startRFIDReading), for: .touchUpInside)

        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    // MARK: - DocumentReader Initialization

    private func initializeDocumentReader() {
        guard let dataPath = Bundle.main.path(forResource: "regula.license", ofType: nil),
              let licenseData = try? Data(contentsOf: URL(fileURLWithPath: dataPath)) else {
            showInitError("Missing regula.license file in bundle")
            return
        }

        let config = DocReader.Config(license: licenseData)
        DocReader.shared.initializeReader(config: config) { [weak self] success, error in
            DispatchQueue.main.async {
                guard let self else { return }
                self.activityIndicator.stopAnimating()
                if success {
                    self.statusLabel.isHidden = true
                    self.showInputControls()
                } else {
                    self.showInitError("Init error: \(error?.localizedDescription ?? "unknown")")
                }
            }
        }
    }

    private func showInputControls() {
        guard let mainStack = keyTypeSegment.superview as? UIStackView else { return }
        mainStack.isHidden = false
        startButton.isEnabled = true
    }

    private func showInitError(_ message: String) {
        activityIndicator.stopAnimating()
        statusLabel.text = message
        statusLabel.textColor = .systemRed
    }

    // MARK: - Key Type Switching

    @objc private func keyTypeChanged() {
        storeCurrentPasswordValue()
        selectedKeyType = KeyType(rawValue: keyTypeSegment.selectedSegmentIndex) ?? .mrz
        updateKeyTypeUI()
    }

    @objc private func passwordFieldChanged() {
        storeCurrentPasswordValue()
    }

    private func updateKeyTypeUI() {
        let isMRZ = selectedKeyType == .mrz
        mrzStack.isHidden = !isMRZ
        passwordStack.isHidden = isMRZ

        passwordField.placeholder = selectedKeyType.passwordPlaceholder
        passwordField.text = isMRZ ? nil : (passwordValues[selectedKeyType] ?? "")
    }

    private func storeCurrentPasswordValue() {
        guard selectedKeyType != .mrz else { return }
        passwordValues[selectedKeyType] = passwordField.text ?? ""
    }

    // MARK: - RFID Reading

    @objc private func startRFIDReading() {
        view.endEditing(true)
        storeCurrentPasswordValue()
        clearResults()

        DocReader.shared.startNewSession()
        DocReader.shared.processParams.scenario = RGL_SCENARIO_RFID

        let rfid = DocReader.shared.rfidScenario
        rfid.pacePasswordType = selectedKeyType.passwordType

        switch selectedKeyType {
        case .mrz:
            rfid.mrz = normalizedMRZ
        case .mrzHash:
            rfid.mrzHash = passwordValues[selectedKeyType] ?? ""
        case .can, .pin, .puk, .pinEsign, .sai:
            rfid.password = passwordValues[selectedKeyType] ?? ""
        }

        DocReader.shared.startRFIDReader(fromPresenter: self) { [weak self] action, results, error in
            guard let self else { return }
            switch action {
            case .complete:
                self.displayResults(results)
            case .cancel:
                self.clearResults()
                self.resultTextView.text = "RFID reading cancelled."
            case .error:
                self.clearResults()
                self.resultTextView.text = "Error: \(error?.localizedDescription ?? "unknown")"
            default:
                break
            }
        }
    }

    // MARK: - Results

    private func displayResults(_ results: DocumentReaderResults?) {
        guard let results else {
            clearResults()
            resultTextView.text = "No results."
            return
        }

        clearResults()
        var lines: [String] = []

        let pa = results.status.detailsRFID.pa
        lines.append("PA Status: \(pa.stringStatus)")

        for field in results.textResult.fields {
            for value in field.values {
                lines.append("\(field.fieldName): \(value.value)")
            }
        }

        if let portrait = results.getGraphicFieldImageByType(fieldType: .gf_Portrait) {
            portraitImageView.image = portrait
            portraitImageView.isHidden = false
        }

        resultTextView.text = lines.joined(separator: "\n")
    }

    // MARK: - Helpers

    private func clearResults() {
        resultTextView.text = nil
        portraitImageView.image = nil
        portraitImageView.isHidden = true
    }

    private var normalizedMRZ: String {
        let rawText = mrzTextView.textColor == .placeholderText ? "" : mrzTextView.text ?? ""
        let lines = rawText
            .components(separatedBy: .newlines)
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines).uppercased() }
            .filter { !$0.isEmpty }

        return lines.joined(separator: "\n")
    }

    private static func makeTextField(placeholder: String) -> UITextField {
        let field = UITextField()
        field.placeholder = placeholder
        field.borderStyle = .roundedRect
        field.autocorrectionType = .no
        field.autocapitalizationType = .none
        field.returnKeyType = .done
        return field
    }
}

// MARK: - UITextViewDelegate

extension ViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        guard textView === mrzTextView, textView.textColor == .placeholderText else { return }
        textView.text = nil
        textView.textColor = .label
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        guard textView === mrzTextView, (textView.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        textView.text = "MRZ (paste full line or lines)"
        textView.textColor = .placeholderText
    }
}

// MARK: - CheckResult Extension

extension CheckResult {
    var stringStatus: String {
        switch self {
        case .error: return "error"
        case .ok: return "ok"
        case .wasNotDone: return "was not done"
        @unknown default: return "unknown"
        }
    }
}
