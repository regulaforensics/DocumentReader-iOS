//
//  MeasureSystem+Extensions.swift
//  DocumentReader-Swift
//
//  Created by Dmitry Evglevsky on 11.02.21.
//  Copyright © 2021 Regula. All rights reserved.
//

import DocumentReader

extension MeasureSystem {
    var stringValue: String {
        switch self {
        case .metric:
            return ".metric"
        case .imperial:
            return ".imperial"
        @unknown default:
            return ""
        }
    }
}
