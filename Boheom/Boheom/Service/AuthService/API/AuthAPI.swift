import Foundation
import Moya

enum AuthAPI {
    case login(_ request: LoginUserInfoRequest)
    case signup
}

extension AuthAPI: BoheomAPI {

    var domain: String {
        switch self {
        case .login:
            return "/login"
        case .signup:
            return "/signup"
        }
    }

    var urlPath: String {
        return ""
    }

    var method: Moya.Method {
        return .post
    }

    var tokenType: JWTTokenType {
        return .none
    }
}
