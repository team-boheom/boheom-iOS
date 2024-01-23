import Foundation

struct PostDetailEntity {
    let id, title, content, username, createdAt: String
    let tags: [String]
    let view, recruitment, applyCount: Int
    let isMine: Bool
}
