import Foundation
import Moya

open class JWTPlugin: PluginType {
    private let tokenStorage = JWTTokenStorage.shared

    public func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
        guard let boheomTarget = target as? BoheomAPI,
              boheomTarget.tokenType != .none else {
            return request
        }

        var appendRequest = request
        appendRequest.addValue(tokenStorage.getToken(ofType: boheomTarget.tokenType), forHTTPHeaderField: boheomTarget.tokenType.keyString)
        return appendRequest
    }
}
