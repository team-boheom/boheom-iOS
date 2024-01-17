import Foundation
import Moya
import RxMoya
import RxSwift

class AuthService {

    private let provider = MoyaProvider<AuthAPI>(plugins: [MoyaLoggingPlugin()])

    private let jwtTokenStorage = JWTTokenStorage.shared

    func login(request: LoginUserInfoRequest) -> Completable {
        provider.rx.request(.login(request))
            .map(LoginTokenResponse.self)
            .map { $0.toDomain() }
            .do(onSuccess: { [weak self] token in
                self?.jwtTokenStorage.saveToken(token: token.accessToken, .accessToken)
            }).catch {
                let moyaError = $0 as? MoyaError
                guard moyaError?.response?.statusCode != nil else { return .error(AuthServiceError.noNetwork) }
                return .error(AuthServiceError.failLogin)
            }
            .asCompletable()
    }
}
