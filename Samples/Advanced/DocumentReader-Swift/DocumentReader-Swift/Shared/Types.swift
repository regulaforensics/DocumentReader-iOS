//
//  Types.swift
//  DocumentReader-Swift
//
//  Created by Dmitry Evglevsky on 9.02.21.
//  Copyright © 2021 Regula. All rights reserved.
//

import DocumentReader

typealias VoidClosure = (() -> (Void))
typealias BoolClosure = ((Bool) -> (Void))
typealias BoolReturnClosure = (() -> (Bool))
typealias IntClosure = ((Int) -> (Void))
typealias IntReturnClosure = (() -> (Int))
typealias StringReturnClosure = (() -> (String))
typealias DocumentReaderResultsClosure = ((DocumentReaderResults) -> (Void))
typealias OptionalBoolClosure = ((Bool?) -> (Void))
typealias OptionalIntClosure = ((Int?) -> (Void))
typealias NSNumberArrayClosure = (([NSNumber]?) -> (Void))
typealias OptionalFloatClosure = ((Float?) -> (Void))

// MARK: - Main screen
enum CustomizationAction {
    case scanner
    case gallery
    case custom
}

class CustomizationItem {
    var title: String
    var customize: VoidClosure
    var actionType: CustomizationAction = .scanner
    var resetFunctionality: Bool = true
    init(_ title: String, _ customize: @escaping VoidClosure = { }) {
        self.title = title
        self.customize = customize
    }
}

class CustomizationSection {
    var title: String
    var items: [CustomizationItem]
    var expanded: Bool = false
    init(_ title: String, _ items: [CustomizationItem]) {
        self.title = title
        self.items = items
    }
}

// MARK: - Settings screen

class SettingsItem {
    var title: String
    init(_ title: String) {
        self.title = title
    }
}

class SettingsBoolItem: SettingsItem {
    var action: BoolClosure
    var state: BoolReturnClosure
    init(title: String, action: @escaping BoolClosure, state: @escaping BoolReturnClosure) {
        self.action = action
        self.state = state
        super.init(title)
    }
}

class SettingsIntItem: SettingsItem {
    var format: String
    var action: IntClosure
    var state: IntReturnClosure
    init(title: String, format: String = "%d", action: @escaping IntClosure,
         state: @escaping IntReturnClosure) {
        self.format = format
        self.action = action
        self.state = state
        super.init(title)
    }
}

class SettingsActionItem: SettingsItem {
    var action: VoidClosure
    var state: StringReturnClosure
    init(title: String, action: @escaping VoidClosure, state: @escaping StringReturnClosure) {
        self.action = action
        self.state = state
        super.init(title)
    }
}

struct SettingsGroup {
    var title: String
    var items: [SettingsItem]
}

// MARK: - Results screen

// General struct for attribute holding
struct Attribute: Hashable {
    var name: String
    var value: String? = nil
    var lcid: LCID? = nil
    var valid: FieldVerificationResult? = nil
    var source: ResultType? = nil
    var image: UIImage? = nil
    var equality: Bool = true
    var rfidStatus: RFIDErrorCodes? = nil
    var checkResult: CheckResult? = nil
    
    // Equatable only by name (used in comparison)
    static func == (lhs: Attribute, rhs: Attribute) -> Bool {
        return lhs.name == rhs.name
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
    }
}

struct GroupedAttributes {
    var type: String = ""
    var items: [Attribute] = []
    
    // Only used in comparison groups:
    var comparisonLHS: ResultType?
    var comparisonRHS: ResultType?
}

// MARK: - Get values screen
struct Parameter: OptionSet {
    let rawValue: Int

    static let fieldType    = Parameter(rawValue: 1 << 0)
    static let lcid         = Parameter(rawValue: 1 << 1)
    static let sourceType   = Parameter(rawValue: 1 << 2)
    static let original     = Parameter(rawValue: 1 << 3)

    static let fieldType_lcid_sourceType_original: Parameter = [.fieldType, .lcid, .sourceType, .original]
    static let fieldType_sourceType_original: Parameter = [.fieldType, .sourceType, .original]
    static let fieldType_lcid_sourceType: Parameter = [.fieldType, .lcid, .sourceType]
    static let fieldType_sourceType: Parameter = [.fieldType, .sourceType]
    static let fieldType_original: Parameter = [.fieldType, .original]
    static let fieldType_lcid: Parameter = [.fieldType, .lcid]
    
    static func made(with indices: [Int]) -> Parameter {
        let rawValue = indices.reduce(Int(0)) { $0 | 1 << Int($1) }
        return Parameter.init(rawValue: rawValue)
    }
}

class ParameterField {
    var title: String
    var isOn: Bool
    var parameter: Parameter
    var selectedItem: Int = 0
    var items: [Int] = []
    var presentedItems: [Int] = []
    init(_ title: String, _ isOn: Bool, _ parameter: Parameter) {
        self.title = title
        self.isOn = isOn
        self.parameter = parameter
    }
}
