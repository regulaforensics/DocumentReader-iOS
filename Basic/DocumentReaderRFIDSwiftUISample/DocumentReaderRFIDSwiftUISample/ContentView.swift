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

    var body: some View {
        NavigationView {
            if reader.isInitialized && !reader.isProcessing {
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
            } else if !reader.isDatabasePrepared {
                Text("Preparing database \(reader.downloadProgress)%...")
            } else if reader.isProcessing {
                ProgressView().progressViewStyle(.circular)
            } else {
                Text("Initializing ...")
            }
        }.navigationViewStyle(.stack)
    }
}
