import Foundation
import RxSwift

class UserService: RestApiRemoteService<UserAPI> {

    func uploadProfile(imageData: Data) -> Completable {
        request(.uploadProfile(imageData: imageData))
            .asCompletable()
    }

    func fetchProfile() -> Single<ProfileEntity> {
        request(.fetchProfile)
            .map(ProfileResponse.self)
            .map { $0.toDomain() }
    }
}
