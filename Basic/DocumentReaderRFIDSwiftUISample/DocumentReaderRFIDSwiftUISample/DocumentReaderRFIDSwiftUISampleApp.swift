//
//  DocumentReaderRFIDSwiftUISampleApp.swift
//  DocumentReaderRFIDSwiftUISample
//
//  Created by Serge Rylko on 25.01.24.
//

import SwiftUI

@main
struct DocumentReaderRFIDSwiftUISampleApp: App {
  var body: some Scene {
    WindowGroup {
      ContentView(reader: ReaderFacade())
    }
  }
}
