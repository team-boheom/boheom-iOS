import Foundation

enum ServiceError: Error {
    case onNetwork, servierError
}

extension ServiceError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .onNetwork:
            return "네트워크 연결을 확인해주세요."
        case .servierError:
            return "서버를 확인해주세요. (Error: Internal Server Error)"
        }
    }
}
