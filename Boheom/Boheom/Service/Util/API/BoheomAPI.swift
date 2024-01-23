import Foundation
import Moya

public protocol BoheomAPI: TargetType {
    var domain: String { get }
    var urlPath: String { get }
    var errorMapper: [Int: Error]? { get }
    var tokenType: JWTTokenType { get }
}

public extension BoheomAPI {
    var baseURL: URL {
        return URL(string: BoheomBundle.shared.getValue(type: .baseURL))!
    }

    var path: String { domain + urlPath }

    var task: Task { .requestPlain }

    var validationType: ValidationType { .successCodes }

    var errorMapper: [Int: Error]? { nil }

    var headers: [String : String]? {
        switch self {
        default:
            return ["Content-Type": "application/json"]
        }
    }
}
