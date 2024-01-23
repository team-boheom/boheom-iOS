import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

class SignupIDViewController: BaseVC<SignupViewModel> {

    var nickName: String?

    private let headerView = SubContentHeader(
        headerText: "아이디를 입력하세요!",
        subContentText: " 님의 아이디를 알려주세요."
    )

    private let inputTextField = BoheomTextField(title: "아이디", placeholder: "아이디를 입력하세요.")
    private let backButton = BoheomButton(
        text: "이전으로 돌아가기",
        font: .captionC1Medium,
        textColor: .gray700,
        type: .text
    )
    private let nextButton = BoheomButton(text: "다음", type: .fill)

    override func attribute() {
        view.backgroundColor = .white
        headerView.contentText = "\(nickName ?? "")님의 아이디를 알려주세요."
    }

    override func bind() {
        let input = SignupViewModel.Input(
            nickNextSignal: nil,
            IdNextSignal: nextButton.rx.tap.asObservable(),
            passwordNextSignal: nil,
            completeNextSignal: nil,
            navigateBackSignal: backButton.rx.tap.asObservable(),
            nickNameTextObservable: nil,
            idTextObservable: inputTextField.textField.rx.text.orEmpty.asObservable(),
            passwordTextObservable: nil,
            passwordCheckTextObservable: nil
        )
        let output = viewModel.transform(input: input)

        output.idNextDisable.asObservable()
            .bind(to: nextButton.rx.isDisable)
            .disposed(by: disposeBag)
    }

    override func addView() {
        view.addSubviews(
            headerView,
            inputTextField,
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
