import UIKit
import RxFlow
import RxSwift
import RxCocoa

class OnBoardingViewModel: ViewModelType, Stepper {

    var steps: PublishRelay<Step> = .init()
    var disposeBag: DisposeBag = .init()

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

        input.loginSignal
            .map { BoheomStep.loginIsRequired }
            .bind(to: steps)
            .disposed(by: disposeBag)

        return Output()
    }
}
