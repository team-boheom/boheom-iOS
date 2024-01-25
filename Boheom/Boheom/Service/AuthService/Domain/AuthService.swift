import Foundation
import Moya
import RxMoya
import RxSwift

class AuthService {

    private let provider = MoyaProvider<AuthAPI>(plugins: [MoyaLoggingPlugin()])

    private let jwtTokenStorage = JWTTokenStorage.shared
    private let keychainStorage = KeychainStorage.shared

    func login(request: LoginUserInfoRequest) -> Completable {
        provider.rx.request(.login(request))
            .map(LoginTokenResponse.self)
            .map { $0.toDomain() }
            .do(onSuccess: { [weak self] token in
                guard let self else { return }
                jwtTokenStorage.saveToken(token: token.accessToken, .accessToken)
                keychainStorage.saveValue(with: request.id, type: userStorageType.id)
                keychainStorage.saveValue(with: request.password, type: userStorageType.password)
            }).catch {
                let moyaError = $0 as? MoyaError
                guard moyaError?.response?.statusCode != nil else { return .error(AuthServiceError.noNetwork) }
                guard let statusCore = moyaError?.response?.statusCode else { return .error($0) }
                switch statusCore {
                case 500: return .error(AuthServiceError.serverError)
                default: return .error(AuthServiceError.failLogin)
                }
            }
            .asCompletable()
    }

    func signup(request: SignupUserInfoRequest) -> Completable {
        provider.rx.request(.signup(request))
            .catch {
                let moyaError = $0 as? MoyaError
                guard moyaError?.response?.statusCode != nil else { return .error(AuthServiceError.noNetwork) }
                guard let statusCore = moyaError?.response?.statusCode else { return .error($0) }
                switch statusCore {
                case 409: return .error(AuthServiceError.conflict)
                default: return .error(AuthServiceError.failSignup)
                }
            }
            .asCompletable()
    }
}
