import Foundation

public struct PostDetailEntity {
    let id, title, content, username, startDay, endDay, createdAt: String
    let tags: [String]
    let view, recruitment, applyCount: Int
    let isMine, isApplied: Bool
}
