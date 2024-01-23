import Foundation

struct ProfileResponse: Decodable {
    enum CodingKeys: String, CodingKey {
        case nickname
        case accountId = "account_id"
        case profile
    }

    let nickname: String
    let accountId: String
    let profile: String
}

extension ProfileResponse {
    func toDomain() -> ProfileEntity {
        return .init(
            nickname: nickname,
            accountId: accountId,
            profile: URL(string: profile)
        )
    }
}
