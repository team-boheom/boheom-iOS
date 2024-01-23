import Foundation

enum FeedServiceError: Error {
    case badRequest, conflict, notFound, noNetwork, serverError
}

extension FeedServiceError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .badRequest:
            return "잘못된 형식의 입력입니다. (Error: Bad Request)"
        case .conflict:
            return "이미 신청한 계시물 입니다."
        case .notFound:
            return "해당 게시물을 찾을 수 없습니다."
        case .noNetwork:
            return "네트워크 연결을 확인해주세요."
        case .serverError:
            return "서버를 확인해주세요. (Error: Internal Server Error)"
        }
    }
}
