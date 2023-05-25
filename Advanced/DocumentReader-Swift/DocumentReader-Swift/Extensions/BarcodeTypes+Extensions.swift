//
//  BarcodeTypes+Extensions.swift
//  DocumentReader-Swift
//
//  Created by Dmitry Evglevsky on 9.02.21.
//  Copyright © 2021 Regula. All rights reserved.
//

import DocumentReader

extension BarcodeType {
    // BarcodeType enum in API written on Objective-C, we can't use CaseIterable
    static var allCases: [BarcodeType] {
        let first = BarcodeType.unknown.rawValue
        let last = BarcodeType.code11.rawValue
        var result: [BarcodeType] = []
        for value in first...last {
            result.append(BarcodeType.init(rawValue: value)!)
        }
        return result
    }
    
    var stringValue: String {
        switch self {
        case .unknown:
            return ".unknown"
        case .code128:
            return ".code128"
        case .code39:
            return ".code39"
        case .EAN8:
            return ".EAN8"
        case .ITF:
            return ".ITF"
        case .PDF417:
            return ".PDF417"
        case .STF:
            return ".STF"
        case .MTF:
            return ".MTF"
        case .IATA:
            return ".IATA"
        case .CODABAR:
            return ".CODABAR"
        case .UPCA:
            return ".UPCA"
        case .CODE93:
            return ".CODE93"
        case .UPCE:
            return ".UPCE"
        case .EAN13:
            return ".EAN13"
        case .QRCODE:
            return ".QRCODE"
        case .AZTEC:
            return ".AZTEC"
        case .DATAMATRIX:
            return ".DATAMATRIX"
        case .ALL_1D:
            return ".ALL_1D"
        case .code11:
            return ".code11"
        @unknown default:
            return ""
        }
    }
}
