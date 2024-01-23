import Foundation
import RxFlow
import RxSwift
import RxCocoa

class HomeViewModel: ViewModelType, Stepper {

    var steps: PublishRelay<Step> = .init()
    var disposeBag: DisposeBag = .init()

    private let userService: UserService
    private let feedService: FeedService

    init( userService: UserService, feedService: FeedService) {
        self.userService = userService
        self.feedService = feedService
    }

    struct Input {
        let profileSignal: Observable<Void>
        let writePostSignal: Observable<Void>
        let footerButtonSignal: Observable<Void>
        let fetchHomeSignal: Observable<Void>
        let navigateDetailSignal: Observable<String>
    }

    struct Output {
        let profileData: Signal<ProfileEntity>
        let recentPostData: Signal<PostListEntity>
        let popularPostData: Signal<PostListEntity>
    }

    func transform(input: Input) -> Output {

        let profileData = PublishRelay<ProfileEntity>()
        let recentPostData = PublishRelay<PostListEntity>()
        let popularPostData = PublishRelay<PostListEntity>()

        input.navigateDetailSignal
            .map { BoheomStep.postDetailIsRequired(postID: $0) }
            .bind(to: steps)
            .disposed(by: disposeBag)

        input.profileSignal
            .map { BoheomStep.profileIsRequired }
            .bind(to: steps)
            .disposed(by: disposeBag)

        input.writePostSignal
            .map { BoheomStep.postWriteIsRequired }
            .bind(to: steps)
            .disposed(by: disposeBag)

        input.footerButtonSignal
            .map { BoheomStep.postWriteIsRequired }
            .bind(to: steps)
            .disposed(by: disposeBag)

        input.fetchHomeSignal
            .flatMap {
                self.userService.fetchProfile()
                    .catch {
                        print($0.localizedDescription)
                        return .never()
                    }
            }
            .bind(to: profileData)
            .disposed(by: disposeBag)

        input.fetchHomeSignal
            .flatMap {
                self.feedService.fetchRecentPost()
                    .catch {
                        print($0.localizedDescription)
                        return .never()
                    }
            }
            .bind(to: recentPostData)
            .disposed(by: disposeBag)

        input.fetchHomeSignal
            .flatMap {
                self.feedService.fetchPopularPost()
                    .catch {
                        print($0.localizedDescription)
                        return .never()
                    }
            }
            .bind(to: popularPostData)
            .disposed(by: disposeBag)

        return Output(
            profileData: profileData.asSignal(),
            recentPostData: recentPostData.asSignal(),
            popularPostData: popularPostData.asSignal()
        )
    }
}
