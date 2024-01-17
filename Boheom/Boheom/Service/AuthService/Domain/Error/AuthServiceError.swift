import Foundation

enum AuthServiceError: Error {
    case failLogin, failSignup, noNetwork
}

extension AuthServiceError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .failLogin:
            return "아이디와 비밀번호를 다시한번 확인해주세요."
        case .failSignup:
            return "회원가입에 실패하였습니다."
        case .noNetwork:
            return "네트워크 연결을 확인해주세요."
        }
    }
}
