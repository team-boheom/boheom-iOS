import Foundation

struct PostResponse: Decodable {
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case content
        case viewerCount = "view"
        case tags
        case recruitment
        case applyCount = "apply_count"
    }

    let id, title, content: String
    let viewerCount, recruitment, applyCount: Int
    let tags: [String]
}

extension PostResponse {
    func toDomain() -> PostEntity {
        return .init(
            id: id,
            title: title,
            content: content,
            viewerCount: viewerCount,
            recruitment: recruitment,
            applyCount: applyCount,
            tags: tags
        )
    }
}
