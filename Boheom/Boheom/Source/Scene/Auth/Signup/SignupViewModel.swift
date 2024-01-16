import UIKit
import RxFlow
import RxSwift
import RxCocoa

class SignupViewModel: ViewModelType, Stepper {

    var steps: PublishRelay<Step> = .init()
    var disposeBag: DisposeBag = .init()

    struct Input {
        let nickNextSignal: Observable<Void>?
        let IdNextSignal: Observable<Void>?
        let passwordNextSignal: Observable<Void>?
        let completeNextSignal: Observable<Void>?
        let navigateBackSignal: Observable<Void>?
    }

    struct Output {}
    
    func transform(input: Input) -> Output {

        input.nickNextSignal?
            .compactMap { _ in BoheomStep.signupID }
            .bind(to: steps)
            .disposed(by: disposeBag)

        input.IdNextSignal?
            .compactMap { _ in BoheomStep.signupPassword }
            .bind(to: steps)
            .disposed(by: disposeBag)

        input.passwordNextSignal?
            .compactMap { _ in BoheomStep.signupComplete }
            .bind(to: steps)
            .disposed(by: disposeBag)

        input.completeNextSignal?
            .compactMap { _ in BoheomStep.loginIsRequired }
            .bind(to: steps)
            .disposed(by: disposeBag)

        input.navigateBackSignal?
            .compactMap { _ in BoheomStep.navigateBackRequired }
            .bind(to: steps)
            .disposed(by: disposeBag)

        return Output()
    }
}
