import Foundation

struct PostListResponse: Decodable {
    enum CodingKeys: String, CodingKey {
        case posts = "feeds"
    }

    let posts: [PostResponse]
}

extension PostListResponse {
    func toDomain() -> PostListEntity {
        return .init(posts: posts.map { $0.toDomain() })
    }
}
