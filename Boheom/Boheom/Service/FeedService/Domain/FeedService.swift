import Foundation
import RxSwift

class FeedService: RestApiRemoteService<FeedAPI> {
    func writePost(request: PostRequest) -> Completable {
        self.request(.writePost(request: request))
            .asCompletable()
    }

    func editPost(feedId: String, request: PostRequest) -> Completable {
        self.request(.editPost(feedId: feedId, request: request))
            .asCompletable()
    }

    func deletePost(feedId: String) -> Completable {
        self.request(.deletePost(feedId: feedId))
            .asCompletable()
    }

    func applyPost(feedId: String) -> Completable {
        self.request(.applyPost(feedId: feedId))
            .asCompletable()
    }

    func cancelApply(feedId: String) -> Completable {
        self.request(.cancelApply(feedId: feedId))
            .asCompletable()
    }

    func fetchPostDetail(feedId: String) -> Single<PostDetailEntity> {
        self.request(.fetchPostDetail(feedId: feedId))
            .map(PostDetailResponse.self)
            .map { $0.toDomain() }
    }

    func fetchRecentPost() -> Single<PostListEntity> {
        self.request(.fetchRecentPost)
            .map(PostListResponse.self)
            .map { $0.toDomain() }
    }

    func fetchPopularPost() -> Single<PostListEntity> {
        self.request(.fetchPopularPost)
            .map(PostListResponse.self)
            .map { $0.toDomain() }
    }

    func fetchApplyPost() -> Single<PostListEntity> {
        self.request(.fetchApplyPost)
            .map(PostListResponse.self)
            .map { $0.toDomain() }
    }

    func fetchMyPost() -> Single<PostListEntity> {
        self.request(.fetchMyPost)
            .map(PostListResponse.self)
            .map { $0.toDomain() }
    }

    func fetchApplyerList(feedId: String) -> Single<ApplyerListEntity> {
        self.request(.fetchApplyerList(feedId: feedId))
            .map(ApplyerListResponse.self)
            .map { $0.toDomain() }
    }
}
