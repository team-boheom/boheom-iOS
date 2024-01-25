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
        let applySignal: Observable<String>
        let cancelApplySignal: Observable<String>
    }

    struct Output {
        let postDatailData: Signal<PostDetailEntity>
        let errorMessage: Signal<String>
        let successMessage: Signal<String>
    }

    func transform(input: Input) -> Output {
        let postDatailData = PublishRelay<PostDetailEntity>()
        let errorMessage = PublishRelay<String>()
        let successMessage = PublishRelay<String>()

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

        input.applySignal
            .flatMap {
                self.feedService.applyPost(feedId: $0)
                    .andThen(Single.just("성공적으로 신청하였습니다!"))
                    .catch {
                        errorMessage.accept($0.localizedDescription)
                        return .never()
                    }
            }
            .bind(to: successMessage)
            .disposed(by: disposeBag)

        input.cancelApplySignal
            .flatMap {
                self.feedService.cancelApply(feedId: $0)
                    .andThen(Single.just("신청을 취소하였습니다."))
                    .catch {
                        errorMessage.accept($0.localizedDescription)
                        return .never()
                    }
            }
            .bind(to: successMessage)
            .disposed(by: disposeBag)

        return Output(
            postDatailData: postDatailData.asSignal(),
            errorMessage: errorMessage.asSignal(),
            successMessage: successMessage.asSignal()
        )
    }
}
