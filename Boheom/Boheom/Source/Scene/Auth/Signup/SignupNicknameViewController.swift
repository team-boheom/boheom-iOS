import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

class SignupNicknameViewController: BaseVC<SignupViewModel> {
    private let headerView = SubContentHeader(
        headerText: "닉네임이 무엇인가요?",
        subContentText: "원하는 닉네임을 입력해주세요."
    )

    private let inputTextField = BoheomTextField(title: "닉네임", placeholder: "닉네임을 입력하세요.")
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
            nickNextSignal: nextButton.rx.tap.asObservable(),
            IdNextSignal: nil,
            passwordNextSignal: nil,
            completeNextSignal: nil,
            navigateBackSignal: backButton.rx.tap.asObservable()
        )
        let _ = viewModel.transform(input: input)
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
