
import UIKit

enum Status {
    case initialization
    case initializationError(String)
    case connectingToDevice
    case connectingToNFC
    case readingRFID
    case empty
}

final class StatusView: UIView {
    
    @IBOutlet private weak var statusLabel: UILabel!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    private func setVisible(_ isVisible: Bool) {
        UIView.animate(withDuration: 0.25) {
            self.alpha = isVisible ? 1 : 0
        }
    }
    
    func setStatus(_ status: Status) {
        switch status {
        case .initialization:
            statusLabel.text = "Initialization..."
            activityIndicator.startAnimating()
            setVisible(true)
        case .initializationError(let error):
            statusLabel.text = "Initialization error: \(error)"
            activityIndicator.stopAnimating()
            setVisible(true)
        case .connectingToDevice:
            statusLabel.text = "Connecting to device..."
            activityIndicator.startAnimating()
            setVisible(true)
        case .connectingToNFC:
            statusLabel.text = "Connecting to NFC..."
            activityIndicator.startAnimating()
            setVisible(true)
        case .readingRFID:
            statusLabel.text = "Reading RFID..."
            activityIndicator.startAnimating()
            setVisible(true)
        case .empty:
            statusLabel.text = ""
            activityIndicator.stopAnimating()
            setVisible(false)
        }
    }
    
}
