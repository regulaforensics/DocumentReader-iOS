//
//  DocReaderFrame+Extensions.swift
//  DocumentReader-Swift
//
//  Created by Dmitry Evglevsky on 12.02.21.
//  Copyright © 2021 Regula. All rights reserved.
//

import DocumentReader

extension DocReaderFrame {
    var stringValue: String {
        switch self {
        case .none:
            return ".none"
        case .scenarioDefault:
            return ".scenarioDefault"
        case .max:
            return ".max"
        case .document:
            return ".document"
        @unknown default:
            return ""
        }
    }
}
