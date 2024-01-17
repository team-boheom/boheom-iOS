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
    }
    
    struct Output {}
    
    func transform(input: Input) -> Output {

        input.signupSignal
            .map { BoheomStep.signupIsRequired }
            .bind(to: steps)
            .disposed(by: disposeBag)

        return Output()
    }
}
