//
//  PKDCertificate+Extensions.swift
//  RfidCertificates-Default-Swift
//
//  Created by Dmitry Evglevsky on 22.03.23.
//  Copyright © 2023 Regula. All rights reserved.
//

import DocumentReader

extension PKDCertificate {
    static func findResourceType(typeName: String) -> PKDResourceType {
        switch typeName.lowercased() {
        case "pa":
            return PKDResourceType.certificate_PA
        case "ta":
            return PKDResourceType.certificate_TA
        case "ldif":
            return PKDResourceType.LDIF
        case "crl":
            return PKDResourceType.CRL
        case "ml":
            return PKDResourceType.ML
        case "defl":
            return PKDResourceType.defL
        case "devl":
            return PKDResourceType.devL
        case "bl":
            return PKDResourceType.BL
        default:
            return PKDResourceType.certificate_PA
        }
    }
}
