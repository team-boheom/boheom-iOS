import Foundation
import Moya

enum FeedAPI {
    case writePost(request: PostRequest)
    case editPost(feedId: String, request: PostRequest)
    case deletePost(feedId: String)
    case applyPost(feedId: String)
    case cancelApply(feedId: String)
    case fetchPostDetail(feedId: String)
    case fetchRecentPost
    case fetchPopularPost
    case fetchApplyPost
    case fetchMyPost
}

extension FeedAPI: BoheomAPI {
    var domain: String { "/feeds" }

    var urlPath: String {
        switch self {
        case .writePost:
            return ""
        case let .editPost(feedId, _):
            return "/\(feedId)"
        case let .deletePost(feedId):
            return "/\(feedId)"
        case let .applyPost(feedId):
            return "/\(feedId)"
        case let .cancelApply(feedId):
            return "/cancel/\(feedId)"
        case let .fetchPostDetail(feedId):
            return "/details/\(feedId)"
        case .fetchRecentPost:
            return "/recent"
        case .fetchPopularPost:
            return "/popular"
        case .fetchApplyPost:
            return "/applied"
        case .fetchMyPost:
            return "/mine"
        }
    }

    var task: Task {
        switch self {
        case let .writePost(request):
            return .requestJSONEncodable(request)
        case let .editPost(_, request):
            return .requestJSONEncodable(request)
        default:
            return .requestPlain
        }
    }

    var errorMapper: [Int : Error]? {
        [
            400: FeedServiceError.badRequest,
            404: FeedServiceError.notFound,
            409: FeedServiceError.conflict
        ]
    }

    var method: Moya.Method {
        switch self {
        case .fetchPostDetail, .fetchRecentPost, .fetchPopularPost, .fetchApplyPost, .fetchMyPost:
            return .get
        case .writePost, .applyPost:
            return .post
        case .editPost:
            return .patch
        case .deletePost, .cancelApply:
            return .delete
        }
    }

    var tokenType: JWTTokenType {
        .accessToken
    }
}
