import Foundation
import RxFlow
import RxSwift
import RxCocoa

class PostDetailViewModel: ViewModelType, Stepper {

    var steps: PublishRelay<Step> = .init()
    var disposeBag: DisposeBag = .init()

    private let feedService: FeedService

    init(feedService: FeedService) {
        self.feedService = feedService
    }

    struct Input {
        let fetchDetailSignal: Observable<String>
    }

    struct Output {
        let postDatailData: Signal<PostDetailEntity>
    }

    func transform(input: Input) -> Output {
        let postDatailData = PublishRelay<PostDetailEntity>()

        input.fetchDetailSignal
            .flatMap {
                self.feedService.fetchPostDetail(feedId: $0)
                    .catch {
                        print($0.localizedDescription)
                        return .never()
                    }
            }
            .bind(to: postDatailData)
            .disposed(by: disposeBag)

        return Output(postDatailData: postDatailData.asSignal())
    }
}
