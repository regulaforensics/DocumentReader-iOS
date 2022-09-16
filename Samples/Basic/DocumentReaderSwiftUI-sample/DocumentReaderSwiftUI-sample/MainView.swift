//
//  MainView.swift
//  DocReader-SUI-Sample
//
//  Created by Dmitry Evglevsky on 12.09.22.
//

import SwiftUI
import DocumentReader
import Combine

struct MainView: View {
    
    @ObservedObject
    var reader: ReaderFacade
    
    @State
    private var isScannerPresented = false
    @State
    private var isGalleryPresented = false
    @State
    private var selectedScenario = ""
    @State
    private var isActive = false

    var body: some View {
        NavigationView {
            if reader.isInitialized {
                VStack {
                    Picker("Scenarious", selection: $selectedScenario) {
                        ForEach(DocReader.shared.availableScenarios, id: \.identifier) {
                            Text($0.identifier)
                        }
                    }
                    .pickerStyle(WheelPickerStyle())
                    .onChange(of: selectedScenario) { newValue in
                        DocReader.shared.processParams.scenario = newValue
                        isActive = true
                    }
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
                }
                
            } else {
                Text("Preparing database \(Int(reader.downloadProgress * 100))%...")
            }
            //TODO: Navigate to ResultView
        }.navigationViewStyle(.stack)
    }
}
