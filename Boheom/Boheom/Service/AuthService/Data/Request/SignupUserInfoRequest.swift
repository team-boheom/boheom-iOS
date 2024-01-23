import Foundation

struct SignupUserInfoRequest: Encodable {
    enum CodingKeys: String, CodingKey {
        case id = "account_id"
        case password
        case nickname
    }

    let id: String
    let password: String
    let nickname: String
}
