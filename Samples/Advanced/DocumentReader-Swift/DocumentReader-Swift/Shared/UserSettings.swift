//
//  UserSettings.swift
//  DocumentReader-Swift
//
//  Created by Dmitry Evglevsky on 9.02.21.
//  Copyright © 2021 Regula. All rights reserved.
//

import Foundation
import DocumentReader

// Helper class for holding settings
class ApplicationSettings {
    static var shared: ApplicationSettings = ApplicationSettings()
    
    var isDataEncryptionEnabled: Bool = false
    var isRfidEnabled: Bool = false
    var useCustomRfidController: Bool = false
    
    var functionality: Functionality = Functionality()
}
