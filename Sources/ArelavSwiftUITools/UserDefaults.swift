import SwiftUI

// https://swiftbysundell.com/articles/property-wrappers-in-swift/

public extension UserDefaults {
    static var shared: UserDefaults {
        let combined = UserDefaults.standard
        let bundle: String = Bundle.main.bundleIdentifier ?? "com.arelav.appbundleid"
        combined.addSuite(named: bundle)
        return combined
    }
}

@propertyWrapper public struct UserDefaultsBacked<Value> {
    public var wrappedValue: Value {
        get {
            let value = storage.value(forKey: key) as? Value
            return value ?? defaultValue
        }
        set {
            storage.setValue(newValue, forKey: key)
        }
    }
    
    private let key: String
    private let defaultValue: Value
    private let storage: UserDefaults
    
    public init(wrappedValue defaultValue: Value,
         key: String,
         storage: UserDefaults = .shared) {
        self.defaultValue = defaultValue
        self.key = key
        self.storage = storage
    }
}
