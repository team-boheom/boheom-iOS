import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

class SignupCompleteViewController: BaseVC<SignupViewModel> {
    private let headerView = SubContentHeader(
        headerText: "회원가입 완료!",
        subContentText: "이제 모험을 시작해볼까요?"
    )

    private let nextButton = BoheomButton(text: "로그인 하러가기", type: .fill)

    override func attribute() {
        view.backgroundColor = .white
        navigationItem.hidesBackButton = true
    }

    override func bind() {
        let input = SignupViewModel.Input(
            nickNextSignal: nil,
            IdNextSignal: nil,
            passwordNextSignal: nil,
            completeNextSignal: nextButton.rx.tap.asObservable(),
            navigateBackSignal: nil
        )
        let _ = viewModel.transform(input: input)
    }

    override func addView() {
        view.addSubviews(headerView, nextButton)
    }

    override func layout() {
        headerView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(80)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        nextButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(44)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }
}
