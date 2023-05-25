//
//  DocumentReaderDocumentType+Extesions.swift
//  DocumentReader-Swift
//
//  Created by Pavel Kondrashkov on 9/14/21.
//  Copyright © 2021 Regula. All rights reserved.
//

import DocumentReader

extension DocFormat: CaseIterable {
    public typealias AllCases = [DocFormat]

    public static var allCases: [DocFormat] = [
        .ID1,
        .ID2,
        .ID3,
        .NON,
        .A4,
        .id3_x2,
        .id2_Turkey,
        .ID1_90,
        .ID1_180,
        .ID1_270,
        .ID2_180,
        .ID3_180,
        .custom,
        .photo,
        .flexible,
    ]
}

extension DocFormat: LosslessStringConvertible {
    public var description: String {
        switch self {
        case .ID1: return "ID1"
        case .ID2: return "ID2"
        case .ID3: return "ID3"
        case .NON: return "NON"
        case .A4: return "A4"
        case .id3_x2: return "id3_x2"
        case .id2_Turkey: return "id2_Turkey"
        case .ID1_90: return "ID1_90"
        case .ID1_180: return "ID1_180"
        case .ID1_270: return "ID1_270"
        case .ID2_180: return "ID2_180"
        case .ID3_180: return "ID3_180"
        case .custom: return "custom"
        case .photo: return "photo"
        case .flexible: return "flexible"
        case .unknown: return "unknown"
        @unknown default:
            fatalError()
        }
    }

    public init?(_ description: String) {
        guard let match = Self.allCases.first(where: { $0.description == description }) else {
            return nil
        }
        self.init(rawValue: match.rawValue)
    }
}
