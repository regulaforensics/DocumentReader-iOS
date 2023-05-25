//
//  CaptureMode+Extensions.swift
//  DocumentReader-Swift
//
//  Created by Dmitry Evglevsky on 11.02.21.
//  Copyright © 2021 Regula. All rights reserved.
//

import DocumentReader

extension CaptureMode {
    var stringValue: String {
        switch self {
        case .auto:
            return ".auto"
        case .captureVideo:
            return ".captureVideo"
        case .captureFrame:
            return ".captureFrame"
        @unknown default:
            return ""
        }
    }
}
