//
//  MRZFormat+Extensions.swift
//  DocumentReader-Swift
//
//  Created by Pavel Kondrashkov on 9/21/21.
//  Copyright © 2021 Regula. All rights reserved.
//

import DocumentReader

extension MRZFormat: CaseIterable {
    public typealias AllCases = [MRZFormat]

    public static var allCases: [MRZFormat] = [
        .IDL,
        .ID1,
        .ID2,
        .ID3,
        .CAN,
        .ID1_2_30,
    ]
}

extension MRZFormat: LosslessStringConvertible {
    public var description: String {
        switch self {
        case .IDL: return "IDL"
        case .ID1: return "ID1"
        case .ID2: return "ID2"
        case .ID3: return "ID3"
        case .CAN: return "CAN"
        case .ID1_2_30: return "ID1_2_30"
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
