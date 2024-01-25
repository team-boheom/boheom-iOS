import Foundation
import SwiftKeychainWrapper

protocol StorageType {
    var key: String { get }
}

enum userStorageType: StorageType {
    case id, password

    var key: String {
        switch self {
        case .id: return "userID"
        case .password: return "userPassword"
        }
    }
}

open class KeychainStorage {
    static let shared = KeychainStorage()
    private init() {}

    func string(ofType type: StorageType) -> String {
        guard let keychainValue = KeychainWrapper.standard.string(forKey: type.key + "keyChain") else {
            print("‼️ [\(NSStringFromClass(KeychainStorage.self))] value is not found.")
            return ""
        }
        return keychainValue
    }

    func saveValue(with value: String, type: StorageType) {
        KeychainWrapper.standard.set(value, forKey: type.key + "keyChain")
    }

    func removeUserInfo() {
        KeychainWrapper.standard.removeObject(forKey: userStorageType.id.key + "keyChain")
        KeychainWrapper.standard.removeObject(forKey: userStorageType.password.key + "keyChain")
    }
}
