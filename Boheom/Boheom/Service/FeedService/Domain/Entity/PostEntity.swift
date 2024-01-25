import Foundation

struct PostEntity {
    let id, title, content: String
    let viewerCount, recruitment, applyCount: Int
    let tags: [String]
    let isApplied: Bool
}
