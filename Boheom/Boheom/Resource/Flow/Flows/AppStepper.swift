import Foundation
import RxFlow
import RxSwift
import RxCocoa

class AppStepper: Stepper {

    var steps: PublishRelay<Step> = .init()
    
    private let disposeBag: DisposeBag = .init()
    private let container = AppDelegate.container
    private let keychainStorage = KeychainStorage.shared

    private let authService: AuthService

    init() {
        self.authService = container.resolve(AuthService.self)!
    }

    func readyToEmitSteps() {
        let userInfo: LoginUserInfoRequest = .init(
            id: keychainStorage.string(ofType: userStorageType.id),
            password: keychainStorage.string(ofType: userStorageType.password)
        )

        authService.login(request: userInfo)
            .subscribe(
                with: self,
                onCompleted: { $0.steps.accept(BoheomStep.homeIsRequired) },
                onError: { owner, _ in owner.steps.accept(BoheomStep.onBoardingIsRequired) }
            ).disposed(by: disposeBag)
    }
}
