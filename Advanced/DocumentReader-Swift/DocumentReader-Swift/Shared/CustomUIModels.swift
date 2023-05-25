//
//  CustomUIModels.swift
//  DocumentReader-Swift
//
//  Created by Dmitry Evglevsky on 20.05.22.
//  Copyright © 2022 Regula. All rights reserved.
//

import Foundation

struct CustomUILayerModel: Codable {
    var objects: [Object]
}

struct Object: Codable {
    var label: Label
}

struct Label: Codable {
    var text, fontStyle, fontColor: String
    let fontSize: Int
    let alignment, background: String
    let borderRadius: Int
    let padding: Padding
    var position: Position
    let margin: Margin
}

struct Margin: Codable {
    let start, end: Int
}

struct Padding: Codable {
    let start, end, top, bottom: Int
}

struct Position: Codable {
    var v: Double
}
