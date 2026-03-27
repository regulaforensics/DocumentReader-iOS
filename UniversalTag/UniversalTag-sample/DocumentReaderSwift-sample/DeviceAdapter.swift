
import CoreNFC
import DocumentReader

final class DeviceAdapter {
    
    /// For start reading NFC Tag
    var tagReadyConnectionCompletion: ((RGLUniversalNFCTagTransport) -> Void)? {
        didSet {
            startDiscovery()
        }
    }
        
}

extension DeviceAdapter {
    
    ///**STEP 1: Search devices
    private func startDiscovery() {

    }
    
    ///**STEP 2: Connect to device
    private func connect() {
        // Connect to the NFC
    }
    
    ///**STEP 3: Start reading
    private func startReading() {
        // Call tagReadyConnectionCompletion after connecting to the NFC
        tagReadyConnectionCompletion?(self)
    }
    
}

//MARK: - Conform to RGLUniversalNFCTagTransport
extension DeviceAdapter: RGLUniversalNFCTagTransport {
    
    func sendApduCommand(data: Data, completionHandler: @escaping (Data, UInt8, UInt8, (any Error)?) -> Void) {
//        deviceManager.sendCommand(data) { result in
//            switch result {
//            case .success(let response):
//                let payload = response.payload
//                completionHandler(payload, response.statusWord1, response.statusWord2, nil)
//            case .failure(let error):
//                completionHandler(Data(),0, 0, error)
//            }
//        }
    }
    
}
