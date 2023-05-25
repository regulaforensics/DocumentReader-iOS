//
//  RFIDAccessControlProcedureType+Extensions.swift
//  DocumentReader-Swift
//
//  Created by Dmitry Evglevsky on 24.02.21.
//  Copyright © 2021 Regula. All rights reserved.
//

import DocumentReader

extension RFIDAccessControlProcedureType {
    var stringValue: String {
        switch self {
        case .undefined:
            return "Undefined"
        case .bac:
            return "BAC"
        case .pace:
            return "PACE"
        case .ca:
            return "CA"
        case .ta:
            return "TA"
        case .aa:
            return "AA"
        case .ri:
            return "RI"
        case .cardInfo:
            return "CARD INFO"
        @unknown default:
            return ""
        }
    }
}
