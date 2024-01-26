import Foundation

struct ApplyerListResponse: Decodable {
    let users: [ProfileResponse]
}

extension ApplyerListResponse {
    func toDomain() -> ApplyerListEntity {
        return .init(users: users.map { $0.toDomain() } )
    }
}
