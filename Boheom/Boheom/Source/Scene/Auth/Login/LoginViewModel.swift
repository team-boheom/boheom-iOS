import UIKit
import RxFlow
import RxSwift
import RxCocoa

class LoginViewModel: ViewModelType, Stepper {

    var steps: PublishRelay<Step> = .init()
    var disposeBag: DisposeBag = .init()

    private let authService: AuthService

    init(authService: AuthService) {
        self.authService = authService
    }

    struct Input {
        let signupSignal: Observable<Void>
        let loginSignal: Observable<Void>
        let idTextObservable: Observable<String>
        let passwordTextObservable: Observable<String>
    }
    
    struct Output {
        let errorMessage: Signal<String>
    }
    
    func transform(input: Input) -> Output {
        let errorMessage = PublishRelay<String>()
        let userInfo = Observable.combineLatest(input.idTextObservable, input.passwordTextObservable)

        input.signupSignal
            .map { BoheomStep.signupIsRequired }
            .bind(to: steps)
            .disposed(by: disposeBag)

        input.loginSignal.withLatestFrom(userInfo)
            .flatMap { id, pwd -> Single<Step> in
                self.authService.login(request: .init(id: id, password: pwd))
                    .andThen(Single.just(BoheomStep.homeIsRequired))
                    .catch {
                        errorMessage.accept($0.localizedDescription)
                        return .never()
                    }
            }
            .bind(to: steps)
            .disposed(by: disposeBag)
            

        return Output(errorMessage: errorMessage.asSignal())
    }
}
