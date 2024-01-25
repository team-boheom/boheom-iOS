import Foundation
import RxFlow
import RxSwift
import RxCocoa

class PostWriteViewModel: ViewModelType, Stepper {

    var steps: PublishRelay<Step> = .init()
    var disposeBag: DisposeBag = .init()

    let feedService: FeedService

    init(feedService: FeedService) {
        self.feedService = feedService
    }

    struct Input {
        let titleTextSignal: Observable<String>
        let contentTextSignal: Observable<String>
        let recruitmentTextSignal: Observable<String>
        let startDayTextSignal: Observable<String?>
        let endDayTextSignal: Observable<String?>
        let tagListSignal: Observable<[String]>
        let writeButtonSignal: Observable<Void>
    }

    struct Output {
        let writeButtonDisable: Driver<Bool>
        let errorMessage: Single<String>
    }

    func transform(input: Input) -> Output {

        let writeButtonDisable = BehaviorRelay<Bool>(value: true)
        let errorMessage = PublishRelay<String>()
        var postRequestData: PostRequest?
        let infoObservable = Observable.combineLatest(
            input.titleTextSignal,
            input.contentTextSignal,
            input.recruitmentTextSignal,
            input.startDayTextSignal,
            input.endDayTextSignal,
            input.tagListSignal
        )

        infoObservable
            .map { title, content, recruitment, startDate, endDate, tags in
                guard let startDate = startDate,
                      let endDate = endDate
                else { return true }

                let status = title.isEmpty ||
                content.isEmpty ||
                recruitment.isEmpty ||
                startDate.isEmpty ||
                endDate.isEmpty ||
                tags.isEmpty
                guard !status else { return true }
                postRequestData = .init(
                    title: title,
                    content: content,
                    recruitment: Int(recruitment)!,
                    startDay: startDate,
                    endDay: endDate,
                    tag: tags
                )

                return status
            }
            .bind(to: writeButtonDisable)
            .disposed(by: disposeBag)

        input.writeButtonSignal
            .compactMap { postRequestData }
            .flatMap {
                self.feedService.writePost(request: $0)
                    .andThen(Single.just(BoheomStep.navigateBackRequired))
                    .catch {
                        errorMessage.accept($0.localizedDescription)
                        return .never()
                    }
            }
            .bind(to: steps)
            .disposed(by: disposeBag)

        return Output(
            writeButtonDisable: writeButtonDisable.asDriver(),
            errorMessage: errorMessage.asSingle()
        )
    }
}
