//
//  ContentView.swift
//  DocumentReaderRFIDSwiftUISample
//
//  Created by Serge Rylko on 25.01.24.
//

import SwiftUI

struct ContentView: View {

  @ObservedObject
  var reader: ReaderFacade

  @State
  private var isScannerPresented = false
  @State
  private var isGalleryPresented = false
  @State
  private var isErrorPresented = false

  var body: some View {
    NavigationView {
      switch reader.state {
      case .notInitialized:
        Text("Not Initialized")
      case .initializing:
        Text("Initializing ...")
      case .ready:
        VStack {
          Picker("Scenarios", selection: $reader.selectedScenario) {
            ForEach(reader.availableScenarios, id: \.self) {
              Text($0)
            }
          }
          .pickerStyle(WheelPickerStyle())
          HStack(spacing: 120) {
            Button("Camera") {
              isScannerPresented.toggle()
            }
            .padding(10)
            .background(Color.accentColor)
            .foregroundColor(.white)
            .cornerRadius(8)
            .fullScreenCover(isPresented: $isScannerPresented, content: {
              CameraView(reader: reader)
            })
          }
          NavigationLink("Results", isActive: $reader.areResultsReady) {
            ResultsView(reader: reader)
          }.hidden()
        }
      case .error(let error):
        VStack {
          Text("Some text \(error)")
          Button("Back") {
            self.reader.state = .ready
          }
        }
      case .initError(let error):
        Text(error)
      }
    }.navigationViewStyle(.stack)
  }
}
