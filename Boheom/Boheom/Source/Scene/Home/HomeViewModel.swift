import Foundation
import RxFlow
import RxSwift
import RxCocoa

class HomeViewModel: ViewModelType, Stepper {

    var steps: PublishRelay<Step> = .init()
    var disposeBag: DisposeBag = .init()

    struct Input {
        let profileSignal: Observable<Void>
    }

    struct Output {
        
    }

    func transform(input: Input) -> Output {
        input.profileSignal
            .map { BoheomStep.profileIsRequired }
            .bind(to: steps)
            .disposed(by: disposeBag)

        return Output()
    }
}
