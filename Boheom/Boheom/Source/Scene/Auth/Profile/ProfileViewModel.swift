import Foundation
import RxFlow
import RxSwift
import RxCocoa

class ProfileViewModel: ViewModelType, Stepper {

    var steps: PublishRelay<Step> = .init()
    var disposeBag: DisposeBag = .init()

    struct Input {
        
    }

    struct Output {
        
    }

    func transform(input: Input) -> Output {
        return Output()
    }
}
