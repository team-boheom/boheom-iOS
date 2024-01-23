import Foundation
import Moya

enum AuthAPI {
    case login(_ request: LoginUserInfoRequest)
    case signup(_ request: SignupUserInfoRequest)
}

extension AuthAPI: BoheomAPI {

    var domain: String {
        return "/users"
    }

    var urlPath: String {
        switch self {
        case .login:
            return "/login"
        case .signup:
            return "/signup"
        }
    }

    var task: Task {
        switch self {
        case let .login(request):
            return .requestJSONEncodable(request)
        case let .signup(request):
            return .requestJSONEncodable(request)
        }
    }

    var method: Moya.Method {
        return .post
    }

    var tokenType: JWTTokenType {
        return .none
    }
}
