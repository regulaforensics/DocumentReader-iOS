//
//  MainView.swift
//  DocReader-SUI-Sample
//
//  Created by Dmitry Evglevsky on 12.09.22.
//

import SwiftUI
import Combine

struct MainView: View {
    
    @ObservedObject
    var reader: ReaderFacade
    
    @State
    private var isScannerPresented = false
    @State
    private var isGalleryPresented = false

    var body: some View {
        NavigationView {
            if reader.isInitialized {
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
                        Button("Gallery") {
                            isGalleryPresented.toggle()
                        }
                        .padding(10)
                        .background(Color.accentColor)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                        .sheet(isPresented: $isGalleryPresented, content: {
                            GalleryView(reader: reader)
                        })
                    }
                    NavigationLink("", isActive: $reader.isResultsReady) {
                        ResultsView(reader: reader)
                    }.hidden()
                }
            } else if !reader.isDatabasePrepared {
                Text("Preparing database \(reader.downloadProgress)%...")
            } else {
                Text("Initializing ...")
            }
        }.navigationViewStyle(.stack)
    }
}
