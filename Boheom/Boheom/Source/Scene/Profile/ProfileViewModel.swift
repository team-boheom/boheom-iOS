import Foundation
import RxFlow
import RxSwift
import RxCocoa

class ProfileViewModel: ViewModelType, Stepper {

    var steps: PublishRelay<Step> = .init()
    var disposeBag: DisposeBag = .init()

    private let userService: UserService
    private let feedServide: FeedService

    init(
        userService: UserService,
        feedServide: FeedService
    ) {
        self.userService = userService
        self.feedServide = feedServide
    }

    struct Input {
        let fetchProfileSignal: Observable<Void>
        let navigateDetailSignal: Observable<String>
    }

    struct Output {
        let profileData: Signal<ProfileEntity>
        let myPostData: Signal<PostListEntity>
        let applyPostData: Signal<PostListEntity>
    }

    func transform(input: Input) -> Output {

        let profileData = PublishRelay<ProfileEntity>()
        let myPostData = PublishRelay<PostListEntity>()
        let applyPostData = PublishRelay<PostListEntity>()

        input.navigateDetailSignal
            .map { BoheomStep.postDetailIsRequired(postID: $0) }
            .bind(to: steps)
            .disposed(by: disposeBag)

        input.fetchProfileSignal
            .flatMap {
                self.userService.fetchProfile()
                    .catch {
                        print($0.localizedDescription)
                        return .never()
                    }
            }
            .bind(to: profileData)
            .disposed(by: disposeBag)

        input.fetchProfileSignal
            .flatMap {
                self.feedServide.fetchMyPost()
                    .catch {
                        print($0.localizedDescription)
                        return .never()
                    }
            }
            .bind(to: myPostData)
            .disposed(by: disposeBag)

        input.fetchProfileSignal
            .flatMap {
                self.feedServide.fetchApplyPost()
                    .catch {
                        print($0.localizedDescription)
                        return .never()
                    }
            }
            .bind(to: applyPostData)
            .disposed(by: disposeBag)
            
        return Output(
            profileData: profileData.asSignal(),
            myPostData: myPostData.asSignal(),
            applyPostData: applyPostData.asSignal()
        )
    }
}
