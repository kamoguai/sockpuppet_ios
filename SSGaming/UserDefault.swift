import UIKit

private protocol AnyOptional {
    var isNil: Bool { get }
}

extension Optional: AnyOptional {
    var isNil: Bool { self == nil }
}

@propertyWrapper
struct UserDefault<T> {
    let key:KeyType
    let defaultValue:T
    var storage:UserDefaults = .standard
    
    
    var wrappedValue: T {
        get {
            return storage.value(forKey: key.rawValue) as? T ?? defaultValue
        }
        set {
            guard let optional = newValue as? AnyOptional, optional.isNil else {
                storage.setValue(newValue, forKey: key.rawValue)
                return
            }
            storage.removeObject(forKey: key.rawValue)
        }
    }
}

extension UserDefault where T: ExpressibleByNilLiteral {
    init(key: KeyType, storage: UserDefaults = .standard) {
        self.init(key: key, defaultValue: nil, storage: storage)
    }
}

extension UserDefault {
    enum KeyType:String {
        case build = "build_preference"
        case version = "version_preference"
    }
}
