import Foundation

enum AuthServiceError: Error {
    case failLogin, failSignup, noNetwork, conflict, serverError
}

extension AuthServiceError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .failLogin:
            return "아이디와 비밀번호를 다시한번 확인해주세요."
        case .failSignup:
            return "회원가입에 실패하였습니다."
        case .conflict:
            return "중복된 아이디입니다. 아이디를 수정해주세요."
        case .noNetwork:
            return "네트워크 연결을 확인해주세요."
        case .serverError:
            return "서버를 확인해주세요. (Error: Internal Server Error)"
        }
    }
}
