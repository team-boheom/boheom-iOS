import Foundation

struct PostDetailResponse: Decodable {
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case content
        case username
        case startDay = "start_day"
        case endDay = "end_day"
        case createdAt = "created_at"
        case tags
        case view
        case recruitment
        case applyCount = "apply_count"
        case isApplied = "is_applied"
        case isMine = "is_mine"
    }

    let id, title, content, username, startDay, endDay, createdAt: String
    let tags: [String]
    let view, recruitment, applyCount: Int
    let isMine, isApplied: Bool
}

extension PostDetailResponse {
    func toDomain() -> PostDetailEntity {
        return .init(
            id: id,
            title: title,
            content: content,
            username: username,
            startDay: startDay,
            endDay: endDay,
            createdAt: createdAt.toDate(.fullDateAndTime).toString("yyyy년 M월 d일"),
            tags: tags,
            view: view,
            recruitment: recruitment,
            applyCount: applyCount,
            isMine: isMine,
            isApplied: isApplied
        )
    }
}
