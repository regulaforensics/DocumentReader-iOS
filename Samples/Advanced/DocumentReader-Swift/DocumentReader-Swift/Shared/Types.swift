//
//  Types.swift
//  DocumentReader-Swift
//
//  Created by Dmitry Evglevsky on 9.02.21.
//  Copyright © 2021 Regula. All rights reserved.
//

import DocumentReader

fileprivate func _setter<Object: AnyObject, Value>(
    for object: Object,
    keyPath: ReferenceWritableKeyPath<Object, Value>
) -> (Value) -> Void {
    return { [weak object] value in
        object?[keyPath: keyPath] = value
    }
}

fileprivate func _getter<Object: AnyObject, Value>(
    for object: Object,
    keyPath: ReferenceWritableKeyPath<Object, Value>
) -> () -> Value {
    return { [weak object] in
        return object![keyPath: keyPath]
    }
}

typealias VoidClosure = (() -> (Void))
typealias StringReturnClosure = (() -> (String))
typealias DocumentReaderResultsClosure = ((DocumentReaderResults) -> (Void))
typealias OptionalBoolClosure = ((Bool?) -> (Void))
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
    var setter: ((Bool) -> (Void))
    var getter: (() -> (Bool))

    init(title: String, setter: @escaping ((Bool) -> (Void)), getter: @escaping (() -> (Bool))) {
        self.setter = setter
        self.getter = getter
        super.init(title)
    }

    convenience init<Object: AnyObject>(title: String, object: Object, keypath: ReferenceWritableKeyPath<Object, Bool>) {
        let setter = _setter(for: object, keyPath: keypath)
        let getter = _getter(for: object, keyPath: keypath)
        self.init(title: title, setter: setter, getter: getter)
    }
}

class SettingsOptionalBoolItem: SettingsItem {
    var setter: (Bool?) -> Void
    var getter: () -> Bool?

    init(title: String, setter: @escaping (Bool?) -> Void, getter: @escaping () -> Bool?) {
        self.setter = setter
        self.getter = getter
        super.init(title)
    }

    convenience init(title: String, setter: @escaping (NSNumber?) -> Void, getter: @escaping () -> NSNumber?) {
        let wrappedSetter: (Bool?) -> Void = { (bool: Bool?) -> Void in
            let number = bool.map { NSNumber(value: $0) }
            setter(number)
        }
        let wrappedGetter: () -> Bool? = {
            return getter()?.boolValue
        }
        self.init(title: title, setter: wrappedSetter, getter: wrappedGetter)
    }

    convenience init<Object: AnyObject>(title: String, object: Object, keypath: ReferenceWritableKeyPath<Object, NSNumber?>) {
        let setter = _setter(for: object, keyPath: keypath)
        let getter = _getter(for: object, keyPath: keypath)
        self.init(title: title, setter: setter, getter: getter)
    }
}


class SettingsIntItem: SettingsItem {
    var format: String
    var setter: (Int) -> Void
    var getter: () -> Int

    init(title: String, format: String = "%d", setter: @escaping (Int) -> Void, getter: @escaping () -> Int) {
        self.format = format
        self.setter = setter
        self.getter = getter
        super.init(title)
    }

    convenience init<Object: AnyObject>(title: String, format: String = "%d", object: Object, keypath: ReferenceWritableKeyPath<Object, Int>) {
        let setter = _setter(for: object, keyPath: keypath)
        let getter = _getter(for: object, keyPath: keypath)
        self.init(title: title, setter: setter, getter: getter)
    }
}

class SettingsOptionalIntItem: SettingsItem {
    var format: String
    var setter: (Int?) -> Void
    var getter: () -> Int?

    init(title: String, format: String = "%d", setter: @escaping (NSNumber?) -> Void, getter: @escaping () -> NSNumber?) {
        self.format = format

        let wrappedSetter: (Int?) -> Void = { (int: Int?) -> Void in
            let number = int.map { NSNumber(value: $0) }
            setter(number)
        }
        let wrappedGetter: () -> Int? = {
            return getter()?.intValue
        }
        self.setter = wrappedSetter
        self.getter = wrappedGetter
        super.init(title)
    }

    convenience init<Object: AnyObject>(title: String, format: String = "%d", object: Object, keypath: ReferenceWritableKeyPath<Object, NSNumber?>) {
        let setter = _setter(for: object, keyPath: keypath)
        let getter = _getter(for: object, keyPath: keypath)
        self.init(title: title, format:format, setter: setter, getter: getter)
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
    var pageIndex: Int? = nil
    var valid: CheckResult? = nil
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
