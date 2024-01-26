import Foundation
import RxSwift
import RxCocoa
import RxFlow

class ApplyerListViewModel: ViewModelType, Stepper {
    var steps: PublishRelay<Step> = .init()
    var disposeBag: DisposeBag = .init()

    let feedService: FeedService

    init(feedService: FeedService) {
        self.feedService = feedService
    }

    struct Input {
        let fetchApplyerListSignal: Observable<String>
    }

    struct Output {
        let applyerListData: Signal<ApplyerListEntity>
    }

    func transform(input: Input) -> Output {
        let applyerListData = PublishRelay<ApplyerListEntity>()

        input.fetchApplyerListSignal
            .throttle(.milliseconds(1000), latest: false, scheduler: MainScheduler.instance)
            .flatMap {
                self.feedService.fetchApplyerList(feedId: $0)
                    .catch {
                        print($0.localizedDescription)
                        return .never()
                    }
            }
            .bind(to: applyerListData)
            .disposed(by: disposeBag)

        return Output(applyerListData: applyerListData.asSignal())
    }
}
