import Foundation

enum UserServiceError: Error {
    case badRequest
}

extension UserServiceError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .badRequest:
            return "잘못된 형식의 입력입니다. (Error: Bad Request)"
        }
    }
}

