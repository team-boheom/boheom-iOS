import Foundation
import Moya
import RxMoya
import RxSwift

class RestApiRemoteService<API: BoheomAPI> {

    private let jwtPlugin: JWTPlugin
    private let loggerPlugin: MoyaLoggingPlugin

    private lazy var provider = MoyaProvider<API>(plugins: [jwtPlugin, loggerPlugin])

    init() {
        self.jwtPlugin = JWTPlugin()
        self.loggerPlugin = MoyaLoggingPlugin()
    }

    public func request(_ api: API) -> Single<Response> {
        provider.rx.request(api)
            .catch {
                let moyaError = $0 as? MoyaError
                guard let errorCode = moyaError?.response?.statusCode,
                      let mappingError = api.errorMapper?[errorCode]
                else { return .error($0) }

                return .error(mappingError)
            }
    }
}
