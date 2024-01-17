import Foundation
import SwiftKeychainWrapper

open class JWTTokenStorage {
    static let shared = JWTTokenStorage()
    private init() {}

    func getToken(ofType tokenType: JWTTokenType) -> String {
        guard let authenticToken = KeychainWrapper.standard.string(forKey: tokenType.tokenName + "keyChain") else {
            print("‼️ [\(NSStringFromClass(JWTTokenStorage.self))] token is not found.")
            return ""
        }
        return authenticToken
    }

    func saveToken(token: String, _ tokenType: JWTTokenType) {
        KeychainWrapper.standard.set(token, forKey: tokenType.tokenName + "keyChain")
    }

    func removeToken() {
        KeychainWrapper.standard.removeObject(forKey: JWTTokenType.accessToken.tokenName + "keyChain")
        KeychainWrapper.standard.removeObject(forKey: JWTTokenType.refreshToken.tokenName + "keyChain")
    }
}
