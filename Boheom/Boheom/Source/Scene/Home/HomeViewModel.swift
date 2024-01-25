import Foundation
import RxFlow
import RxSwift
import RxCocoa

class HomeViewModel: ViewModelType, Stepper {

    var steps: PublishRelay<Step> = .init()
    var disposeBag: DisposeBag = .init()

    private let userService: UserService
    private let feedService: FeedService

    private var recentPostList: [PostEntity] = []
    private var popularPostList: [PostEntity] = []

    private let recentPostData = PublishRelay<PostListEntity>()
    private let popularPostData = PublishRelay<PostListEntity>()

    init( userService: UserService, feedService: FeedService) {
        self.userService = userService
        self.feedService = feedService
    }

    struct Input {
        let profileSignal: Observable<Void>
        let writePostSignal: Observable<Void>
        let footerButtonSignal: Observable<Void>
        let fetchHomeSignal: Observable<Void>
        let applySignal: Observable<String>
        let cancelApplySignal: Observable<String>
        let navigateDetailSignal: Observable<String>
    }

    struct Output {
        let profileData: Signal<ProfileEntity>
        let recentPostData: Signal<PostListEntity>
        let popularPostData: Signal<PostListEntity>
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
                        errorMessage.accept($0.localizedDescription)
                        return .never()
                    }
            }
            .bind(to: profileData)
            .disposed(by: disposeBag)

        input.fetchHomeSignal
            .flatMap {
                self.feedService.fetchRecentPost()
                    .catch {
                        errorMessage.accept($0.localizedDescription)
                        return .never()
                    }
            }
            .bind(with: self, onNext: { owner, data in
                owner.recentPostList = data.posts
                owner.recentPostData.accept(data)
            })
            .disposed(by: disposeBag)

        input.fetchHomeSignal
            .flatMap {
                self.feedService.fetchPopularPost()
                    .catch {
                        errorMessage.accept($0.localizedDescription)
                        return .never()
                    }
            }
            .bind(with: self, onNext: { owner, data in
                owner.popularPostList = data.posts
                owner.popularPostData.accept(data)
            })
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

        return Output(
            profileData: profileData.asSignal(),
            recentPostData: recentPostData.asSignal(),
            popularPostData: popularPostData.asSignal(),
            errorMessage: errorMessage.asSignal(),
            successMessage: successMessage.asSignal()
        )
    }
}

extension HomeViewModel {
    private func changePostValue(postID: String) {
        changeRecentPost(postID: postID)
        changePopularPost(postID: postID)

        recentPostData.accept(.init(posts: recentPostList))
        popularPostData.accept(.init(posts: popularPostList))
    }

    private func changeRecentPost(postID: String) {
        guard let recentIndex = recentPostList.firstIndex(where: { $0.id == postID }) else { return }
        let targetPost = recentPostList[recentIndex]
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
        recentPostList[recentIndex] = changePost
    }

    private func changePopularPost(postID: String) {
        guard let recentIndex = popularPostList.firstIndex(where: { $0.id == postID }) else { return }
        let targetPost = popularPostList[recentIndex]
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
        popularPostList[recentIndex] = changePost
    }
}
