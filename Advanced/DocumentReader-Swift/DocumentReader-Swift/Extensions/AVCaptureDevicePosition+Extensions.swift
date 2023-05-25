//
//  AVCaptureDevicePosition+Extensions.swift
//  DocumentReader-Swift
//
//  Created by Dmitry Evglevsky on 11.02.21.
//  Copyright © 2021 Regula. All rights reserved.
//

import AVFoundation

extension AVCaptureDevice.Position {
    var stringValue: String {
        switch self {
        case .unspecified:
            return ".unspecified"
        case .back:
            return ".back"
        case .front:
            return ".front"
        @unknown default:
            return ""
        }
    }
}
