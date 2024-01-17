import Foundation

struct LoginTokenResponse: Decodable {
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case refreshToken = "refresh_token"
    }

    let accessToken: String
    let refreshToken: String
}

extension LoginTokenResponse {
    func toDomain() -> LoginTokenEntity {
        .init(accessToken: accessToken)
    }
}
