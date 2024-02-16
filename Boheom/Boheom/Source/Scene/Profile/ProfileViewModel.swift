import Foundation
import RxFlow
import RxSwift
import RxCocoa

class ProfileViewModel: ViewModelType, Stepper {

    var steps: PublishRelay<Step> = .init()
    var disposeBag: DisposeBag = .init()

    private let userService: UserService
    private let feedService: FeedService

    private var myPostList: [PostEntity] = []
    private var applyPostList: [PostEntity] = []

    private let myPostData = PublishRelay<PostListEntity>()
    private let applyPostData = PublishRelay<PostListEntity>()

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
        let uploadImageSignal: Observable<Data>
        let logoutSignal: Observable<Void>
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
            .bind(with: self, onNext: { owner, data in
                owner.myPostList = data.posts
                owner.myPostData.accept(data)
            })
            .disposed(by: disposeBag)

        input.fetchProfileSignal
            .flatMap {
                self.feedService.fetchApplyPost()
                    .catch {
                        errorMessage.accept($0.localizedDescription)
                        return .never()
                    }
            }
            .bind(with: self, onNext: { owner, data in
                owner.applyPostList = data.posts
                owner.applyPostData.accept(data)
            })
            .disposed(by: disposeBag)

        input.uploadImageSignal
            .flatMap {
                self.userService.uploadProfile(imageData: $0)
                    .andThen(Single.just("프로필 이미지를 변경하였습니다."))
                    .catch {
                        errorMessage.accept($0.localizedDescription)
                        return .never()
                    }
            }
            .bind(to: successMessage)
            .disposed(by: disposeBag)

        input.applySignal
            .flatMap {
                self.feedService.applyPost(feedId: $0)
                    .andThen(Single.just((message:"성공적으로 신청하였습니다!", postID: $0)))
                    .catch {
                        errorMessage.accept($0.localizedDescription)
                        return .never()
                    }
            }
            .bind(with: self, onNext: { owner, data in
                owner.changePostValue(postID: data.postID)
                successMessage.accept(data.message)
            })
            .disposed(by: disposeBag)

        input.cancelApplySignal
            .flatMap {
                self.feedService.cancelApply(feedId: $0)
                    .andThen(Single.just((message:"신청을 취소하였습니다.", postID: $0)))
                    .catch {
                        errorMessage.accept($0.localizedDescription)
                        return .never()
                    }
            }
            .bind(with: self, onNext: { owner, data in
                owner.changePostValue(postID: data.postID)
                successMessage.accept(data.message)
            })
            .disposed(by: disposeBag)

        input.logoutSignal
            .map { BoheomStep.onBoardingIsRequired }
            .bind(to: steps)
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

extension ProfileViewModel {
    private func changePostValue(postID: String) {
        changeMyPost(postID: postID)
        changeApplyPost(postID: postID)

        myPostData.accept(.init(posts: myPostList))
        applyPostData.accept(.init(posts: applyPostList))
    }

    private func changeMyPost(postID: String) {
        guard let myPostIndex = myPostList.firstIndex(where: { $0.id == postID }) else { return }
        let targetPost = myPostList[myPostIndex]
        let changePost: PostEntity = .init(
            id: targetPost.id,
            title: targetPost.title,
            content: targetPost.content,
            viewerCount: targetPost.viewerCount,
            recruitment: targetPost.recruitment,
            applyCount: targetPost.applyCount + (targetPost.isApplied ? -1 : 1),
            tags: targetPost.tags,
            isApplied: !targetPost.isApplied
        )
        myPostList[myPostIndex] = changePost
    }

    private func changeApplyPost(postID: String) {
        guard let applyIndex = applyPostList.firstIndex(where: { $0.id == postID }) else { return }
        applyPostList.remove(at: applyIndex)
    }
}
