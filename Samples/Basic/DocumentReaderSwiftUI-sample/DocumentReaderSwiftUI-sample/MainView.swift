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

    var body: some View {
        VStack {
            if reader.isInitialized {
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
            } else {
                Text("Initializing Core...")
            }
            if !isScannerPresented && reader.lastResults != nil {
                ResultsView(reader: reader)
            }
        }
    }
}
