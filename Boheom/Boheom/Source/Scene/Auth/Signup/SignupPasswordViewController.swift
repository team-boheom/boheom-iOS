import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

class SignupPasswordViewController: BaseVC<SignupViewModel> {

    private let headerView = SubContentHeader(
        headerText: "비밀번호는 무엇인가요?",
        subContentText: "이제 마지막 입니다. 비밀번호를 알려주세요!"
    )

    private let inputTextField = BoheomTextField(title: "비밀번호", placeholder: "비밀번호를 입력하세요.", isSecure: true)
    private let inputCheckTextField = BoheomTextField(title: "비밀번호 확인", placeholder: "같은 비밀번호를 입력하세요.", isSecure: true)
    private let backButton = BoheomButton(
        text: "이전으로 돌아가기",
        font: .captionC1Medium,
        textColor: .gray700,
        type: .text
    )
    private let nextButton = BoheomButton(text: "다음", type: .fill)

    override func attribute() {
        view.backgroundColor = .white
    }

    override func bind() {
        let input = SignupViewModel.Input(
            nickNextSignal: nil,
            IdNextSignal: nil,
            passwordNextSignal: nextButton.rx.tap.asObservable(),
            completeNextSignal: nil,
            navigateBackSignal: backButton.rx.tap.asObservable(),
            nickNameTextObservable: nil,
            idTextObservable: nil,
            passwordTextObservable: inputTextField.textField.rx.text.orEmpty.asObservable(),
            passwordCheckTextObservable: inputCheckTextField.textField.rx.text.orEmpty.asObservable()
        )
        let output = viewModel.transform(input: input)

        output.passwordNextDisable.asObservable()
            .bind(to: nextButton.rx.isDisable)
            .disposed(by: disposeBag)

        output.errorMessage.asObservable()
            .bind(with: self, onNext: { owner, message in
                let toastView = BoheomToastyView(type: .error)
                toastView.content = message
                owner.toastController.present(with: toastView)
            })
            .disposed(by: disposeBag)
    }

    override func addView() {
        view.addSubviews(
            headerView,
            inputTextField,
            inputCheckTextField,
            backButton,
            nextButton
        )
    }

    override func layout() {
        headerView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(80)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        inputTextField.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.top.equalTo(headerView.snp.bottom).offset(56)
        }
        inputCheckTextField.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.top.equalTo(inputTextField.snp.bottom).offset(20)
        }
        backButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(nextButton.snp.top).offset(-15)
        }
        nextButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(44)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }
}
