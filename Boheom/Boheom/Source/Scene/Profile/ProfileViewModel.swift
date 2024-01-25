import Foundation
import RxFlow
import RxSwift
import RxCocoa

class ProfileViewModel: ViewModelType, Stepper {

    var steps: PublishRelay<Step> = .init()
    var disposeBag: DisposeBag = .init()

    private let userService: UserService
    private let feedService: FeedService

    init(
        userService: UserService,
        feedService: FeedService
    ) {
        self.userService = userService
        self.feedService = feedService
    }

    struct Input {
        let fetchProfileSignal: Observable<Void>
        let applySignal: Observable<String>
        let cancelApplySignal: Observable<String>
        let navigateDetailSignal: Observable<String>
    }

    struct Output {
        let profileData: Signal<ProfileEntity>
        let myPostData: Signal<PostListEntity>
        let applyPostData: Signal<PostListEntity>
        let errorMessage: Signal<String>
        let successMessage: Signal<String>
    }

    func transform(input: Input) -> Output {

        let profileData = PublishRelay<ProfileEntity>()
        let myPostData = PublishRelay<PostListEntity>()
        let applyPostData = PublishRelay<PostListEntity>()
        let errorMessage = PublishRelay<String>()
        let successMessage = PublishRelay<String>()

        input.navigateDetailSignal
            .map { BoheomStep.postDetailIsRequired(postID: $0) }
            .bind(to: steps)
            .disposed(by: disposeBag)

        input.fetchProfileSignal
            .flatMap {
                self.userService.fetchProfile()
                    .catch {
                        errorMessage.accept($0.localizedDescription)
                        return .never()
                    }
            }
            .bind(to: profileData)
            .disposed(by: disposeBag)

        input.fetchProfileSignal
            .flatMap {
                self.feedService.fetchMyPost()
                    .catch {
                        errorMessage.accept($0.localizedDescription)
                        return .never()
                    }
            }
            .bind(to: myPostData)
            .disposed(by: disposeBag)

        input.fetchProfileSignal
            .flatMap {
                self.feedService.fetchApplyPost()
                    .catch {
                        errorMessage.accept($0.localizedDescription)
                        return .never()
                    }
            }
            .bind(to: applyPostData)
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
            profileData: profileData.asSignal(),
            myPostData: myPostData.asSignal(),
            applyPostData: applyPostData.asSignal(),
            errorMessage: errorMessage.asSignal(),
            successMessage: successMessage.asSignal()
        )
    }
}
