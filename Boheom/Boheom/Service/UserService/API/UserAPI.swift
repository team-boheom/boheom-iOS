import Foundation
import Moya

enum UserAPI {
    case uploadProfile(imageData: Data)
    case fetchProfile
}

extension UserAPI: BoheomAPI {
    var domain: String { "/users" }
    
    var urlPath: String {
        switch self {
        case .uploadProfile:
            return "/upload"
        case .fetchProfile:
            return ""
        }
    }

    var errorMapper: [Int : Error]? {
        [
            400: UserServiceError.badRequest,
            500: UserServiceError.serverError
        ]
    }

    var task: Task {
        switch self {
        case let .uploadProfile(imageData):
            let multipartData: [MultipartFormData] = [
                .init(
                    provider: .data(imageData),
                    name: "file",
                    fileName: "file.jpg",
                    mimeType: "image/jpg"
                )
            ]
            return .uploadMultipart(multipartData)
        case .fetchProfile:
            return .requestPlain
        }
    }

    var method: Moya.Method {
        switch self {
        case .uploadProfile:
            return .post
        case .fetchProfile:
            return .get
        }
    }

    var tokenType: JWTTokenType {
        .accessToken
    }
}
