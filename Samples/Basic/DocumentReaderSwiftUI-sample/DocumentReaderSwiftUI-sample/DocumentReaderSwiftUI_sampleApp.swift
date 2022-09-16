//
//  DocumentReaderSwiftUI_sampleApp.swift
//  DocumentReaderSwiftUI-sample
//
//  Created by Dmitry Evglevsky on 13.09.22.
//

import SwiftUI

@main
struct DocumentReaderSwiftUI_sampleApp: App {
    var body: some Scene {
        WindowGroup {
            MainView(reader: ReaderFacade())
        }
    }
}
