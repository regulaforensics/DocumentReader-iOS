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
    @State
    private var isActive = false

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
                    .onChange(of: reader.selectedScenario) { newValue in
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
                
            } else if !reader.dataBasePrepared {
                Text("Preparing database \(reader.downloadProgress)%...")
            } else {
                Text("Initializing ...")
            }
            //TODO: Navigate to ResultView
        }.navigationViewStyle(.stack)
    }
}
