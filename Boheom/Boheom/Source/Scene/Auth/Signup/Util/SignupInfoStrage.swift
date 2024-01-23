import Foundation

class SignupInfoStrage {
    
    static let shared = SignupInfoStrage()
    private init() {}

    var id: String?
    var password: String?
    var nickName: String?

    func toSignupRequest() -> SignupUserInfoRequest? {
        guard let id = self.id,
              let password = self.password,
              let nickName = self.nickName
        else {
            debugPrint("‼️ SignupInfo is nil.")
            return nil
        }
        return .init(id: id, password: password, nickname: nickName)
    }
}
