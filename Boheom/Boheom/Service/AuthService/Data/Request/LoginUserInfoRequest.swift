import Foundation

struct LoginUserInfoRequest: Encodable {
    enum CodingKeys: String, CodingKey {
        case id = "account_id"
        case password
    }

    let id: String
    let password: String
}
