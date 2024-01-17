import Foundation

public enum JWTTokenType {
    case accessToken, refreshToken, none

    var keyString: String {
        switch self {
        case .accessToken:
            return "Authorization"
        case .refreshToken:
            return "refresh"
        default:
            return ""
        }
    }

    var tokenName: String {
        switch self {
        case .accessToken:
            return "accessToken"
        case .refreshToken:
            return "refreshToken"
        default:
            return "none"
        }
    }
}
