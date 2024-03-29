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
    
    @State
    private var pageIndex = 0
    
    var body: some View {
        Picker("Results Page", selection: $pageIndex) {
            Text("Text").tag(0)
            Text("Graphics").tag(1)
        }
        .pickerStyle(SegmentedPickerStyle())
        
        if pageIndex == 0 {
            List(reader.lastTextResultFields, id: \.fieldName) { field in
                HStack {
                    Text(field.fieldName + ":").fontWeight(.light).foregroundColor(Color.secondary)
                    Text(field.values.first?.value ?? "").fontWeight(.light).foregroundColor(Color.primary)
                }
            }
        } else {
            GeometryReader { geo in
                List(reader.lastGraphicResultFields, id: \.hash) { field in
                    VStack {
                        Text(field.fieldName)
                            .fontWeight(.light)
                            .foregroundColor(Color.secondary)
                        Image(uiImage: field.value)
                            .resizable()
                            .scaledToFit()
                            .frame(width: geo.size.width)
                    }
                }
            }
        }
    }
}
