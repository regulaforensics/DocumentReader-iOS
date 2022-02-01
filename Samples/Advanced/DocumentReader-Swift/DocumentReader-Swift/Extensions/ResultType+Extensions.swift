//
//  ResultType+Extensions.swift
//  DocumentReader-Swift
//
//  Created by Dmitry Evglevsky on 2/4/21.
//  Copyright © 2021 Regula. All rights reserved.
//

import DocumentReader

extension ResultType {
    var stringValue: String {
        switch self {
        case .empty: return ".empty"
        case .rawImage: return ".rawImage"
        case .fileImage: return ".fileImage"
        case .mrzOCRExtended: return ".mrzOCRExtended"
        case .barCodes: return ".barCodes"
        case .graphics: return ".graphics"
        case .mrzTestQuality: return ".mrzTestQuality"
        case .documentTypesCandidates: return ".documentTypesCandidates"
        case .chosenDocumentTypeCandidate: return ".chosenDocumentTypeCandidate"
        case .documentsInfoList: return ".documentsInfoList"
        case .ocrLexicalAnalyze: return ".ocrLexicalAnalyze"
        case .rawUncroppedImage: return ".rawUncroppedImage"
        case .visualOCRExtended: return ".visualOCRExtended"
        case .barCodesTextData: return ".barCodesTextData"
        case .barCodesImageData: return ".barCodesImageData"
        case .authenticity: return ".authenticity"
        case .expertAnalyze: return ".expertAnalyze"
        case .ocrLexicalAnalyzeEx: return ".ocrLexicalAnalyzeEx"
        case .eosImage: return ".eosImage"
        case .bayer: return ".bayer"
        case .magneticStripe: return ".magneticStripe"
        case .magneticStripeTextData: return ".magneticStripeTextData"
        case .fieldFileImage: return ".fieldFileImage"
        case .databaseCheck: return ".databaseCheck"
        case .fingerprintTemplateISO: return ".fingerprintTemplateISO"
        case .inputImageQuality: return ".inputImageQuality"
        case .status: return ".status"
        case .images: return ".images"
        case .mrzPosition: return ".mrzPosition"
        case .barcodePosition: return ".barcodePosition"
        case .documentPosition: return ".documentPosition"
        case .custom: return ".custom"
        case .rfidRawData: return ".rfidRawData"
        case .rfidTextData: return ".rfidTextData"
        case .rfidImageData: return ".rfidImageData"
        case .rfidBinaryData: return ".rfidBinaryData"
        case .rfidOriginalGraphics: return ".rfidOriginalGraphics"
        @unknown default:
            return ""
        }
    }
}

extension ResultType {
    static var allCases: [ResultType] = [
        .empty, .rawImage, .fileImage, .mrzOCRExtended, .barCodes, .graphics,
        .mrzTestQuality, .documentTypesCandidates, .chosenDocumentTypeCandidate,
        .documentsInfoList, .ocrLexicalAnalyze, .rawUncroppedImage,
        .visualOCRExtended, .barCodesTextData, .barCodesImageData, .authenticity,
        .expertAnalyze, .ocrLexicalAnalyzeEx, .eosImage, .bayer, .magneticStripe,
        .magneticStripeTextData, .fieldFileImage, .databaseCheck, .fingerprintTemplateISO,
        .inputImageQuality, .mrzPosition, .barcodePosition, .documentPosition, .custom,
        .rfidRawData, .rfidTextData, .rfidImageData, .rfidBinaryData, .rfidOriginalGraphics, .images
    ]
}
