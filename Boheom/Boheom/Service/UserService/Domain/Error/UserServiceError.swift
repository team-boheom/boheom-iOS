import Foundation

enum UserServiceError: Error {
    case badRequest, noNetwork, serverError
}

extension UserServiceError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .badRequest:
            return "잘못된 형식의 입력입니다. (Error: Bad Request)"
        case .noNetwork:
            return "네트워크 연결을 확인해주세요."
        case .serverError:
            return "서버를 확인해주세요. (Error: Internal Server Error)"
        }
    }
}

