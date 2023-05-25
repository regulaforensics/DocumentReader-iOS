//
//  GalleryView.swift
//  DocReader-SUI-Sample
//
//  Created by Dmitry Evglevsky on 13.09.22.
//

import SwiftUI

struct GalleryView: View {
    let reader: ReaderFacade
    
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        GalleryViewController(reader: reader)
    }
}

struct GalleryViewController: UIViewControllerRepresentable {
    typealias UIViewControllerType = UIViewController
    let reader: ReaderFacade
    
    func makeUIViewController(context: Context) -> UIViewController {
        reader.getGalleryController()
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}
