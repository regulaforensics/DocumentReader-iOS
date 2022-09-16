//
//  ResultsView.swift
//  DocReader-SUI-Sample
//
//  Created by Dmitry Evglevsky on 12.09.22.
//

import SwiftUI
import DocumentReader

struct ResultsView: View {
    let reader: ReaderFacade
    
    var body: some View {
        TabView {
            List(reader.lastTextResultFields, id: \.fieldName) { field in
                HStack {
                    Text(field.fieldName + ":").fontWeight(.light).foregroundColor(Color.secondary)
                    Text(field.values.first?.value ?? "").fontWeight(.light).foregroundColor(Color.primary)
                }
            }
            .tabItem {
                Label("Text", systemImage: "character.textbox")
            }
            List(reader.lastGraphicResultFields, id: \.fieldName) { field in
                VStack {
                    Text(field.fieldName).fontWeight(.light).foregroundColor(Color.secondary)
                    Image(uiImage: field.value).resizable().scaledToFit()
                }
            }
            .tabItem {
                Label("Graphics", systemImage: "photo")
            }
        }
    }
}
