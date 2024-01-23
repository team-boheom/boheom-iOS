import UIKit
import RxFlow
import RxSwift
import RxCocoa

class SignupViewModel: ViewModelType, Stepper {

    var steps: PublishRelay<Step> = .init()
    var disposeBag: DisposeBag = .init()

    private let authService: AuthService
    private let infoChecker: InfoChecker
    private let signupStage: SignupInfoStrage

    init(authService: AuthService) {
        self.authService = authService
        self.infoChecker = InfoChecker()
        self.signupStage = SignupInfoStrage.shared
    }

    struct Input {
        let nickNextSignal: Observable<Void>?
        let IdNextSignal: Observable<Void>?
        let passwordNextSignal: Observable<Void>?
        let completeNextSignal: Observable<Void>?
        let navigateBackSignal: Observable<Void>?
        let nickNameTextObservable: Observable<String>?
        let idTextObservable: Observable<String>?
        let passwordTextObservable: Observable<String>?
        let passwordCheckTextObservable: Observable<String>?
    }

    struct Output {
        let nickNextDisable: Driver<Bool>
        let idNextDisable: Driver<Bool>
        let passwordNextDisable: Driver<Bool>
        let errorMessage: Signal<String>
    }

    func transform(input: Input) -> Output {

        let nickNextDisable = BehaviorRelay<Bool>(value: true)
        let idNextDisable = BehaviorRelay<Bool>(value: true)
        let passwordNextDisable = BehaviorRelay<Bool>(value: true)
        let errorMessage = PublishRelay<String>()
        let passwordBundle = Observable.combineLatest(input.passwordTextObservable ?? .never(), input.passwordCheckTextObservable ?? .never())

        input.nickNameTextObservable?
            .map { (!self.infoChecker.checkValid(of: .nickname, $0), $0) }
            .bind(with: self, onNext: { owner, data in
                owner.signupStage.nickName = data.1
                nickNextDisable.accept(data.0)
            })
            .disposed(by: disposeBag)

        input.idTextObservable?
            .map { (!self.infoChecker.checkValid(of: .id, $0), $0) }
            .bind(with: self, onNext: { owner, data in
                owner.signupStage.id = data.1
                idNextDisable.accept(data.0)
            })
            .disposed(by: disposeBag)

        passwordBundle
            .map { (!(self.infoChecker.checkValid(of: .password, $0.0) && $0.0 == $0.1), $0.0) }
            .bind(with: self, onNext: { owner, data in
                owner.signupStage.password = data.1
                passwordNextDisable.accept(data.0)
            })
            .disposed(by: disposeBag)

        input.nickNextSignal?
            .compactMap { _ in BoheomStep.signupID }
            .bind(to: steps)
            .disposed(by: disposeBag)

        input.IdNextSignal?
            .compactMap { _ in BoheomStep.signupPassword }
            .bind(to: steps)
            .disposed(by: disposeBag)

        input.passwordNextSignal?
            .compactMap { _ in self.signupStage.toSignupRequest() }
            .flatMap { request -> Single<Step> in
                self.authService.signup(request: request)
                    .andThen(Single.just(BoheomStep.signupComplete))
                    .catch {
                        errorMessage.accept($0.localizedDescription)
                        return .never()
                    }
            }
            .bind(to: steps)
            .disposed(by: disposeBag)

        input.completeNextSignal?
            .compactMap { _ in BoheomStep.loginIsRequired }
            .bind(to: steps)
            .disposed(by: disposeBag)

        input.navigateBackSignal?
            .compactMap { _ in BoheomStep.navigateBackRequired }
            .bind(to: steps)
            .disposed(by: disposeBag)

        return Output(
            nickNextDisable: nickNextDisable.asDriver(),
            idNextDisable: idNextDisable.asDriver(),
            passwordNextDisable: passwordNextDisable.asDriver(),
            errorMessage: errorMessage.asSignal()
        )
    }
}
