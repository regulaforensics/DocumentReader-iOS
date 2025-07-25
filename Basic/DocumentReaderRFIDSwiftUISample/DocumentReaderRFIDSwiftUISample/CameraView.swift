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
      Color.black.edgesIgnoringSafeArea(.all)
      CameraViewController(reader: reader)
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
