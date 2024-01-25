import Foundation

enum FeedServiceError: Error {
    case badRequest, conflict, notFound
}

extension FeedServiceError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .badRequest:
            return "자신의 글에는 신청할 수 없습니다."
        case .conflict:
            return "이미 신청한 계시물 입니다."
        case .notFound:
            return "해당 게시물을 찾을 수 없습니다."
        }
    }
}
