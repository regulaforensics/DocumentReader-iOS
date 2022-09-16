//
//  CameraView.swift
//  DocReader-SUI-Sample
//
//  Created by Dmitry Evglevsky on 12.09.22.
//

import SwiftUI
import DocumentReader

struct CameraView: View {
    let reader: ReaderFacade
    
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        ZStack {
            Color.primary.edgesIgnoringSafeArea(.all)
            CameraViewController(reader: reader)
            VStack {
                Text("Custom Text Over Scanner")
                    .foregroundColor(Color.green)
                    .font(.system(size: 20))
                    .padding(EdgeInsets(top: 120, leading: 0, bottom: 0, trailing: 0))
                Spacer()
            }
        }
    }
}

struct CameraViewController: UIViewControllerRepresentable {
    typealias UIViewControllerType = UIViewController
    let reader: ReaderFacade
    
    func makeUIViewController(context: Context) -> UIViewController {
        reader.getCameraController()
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}
