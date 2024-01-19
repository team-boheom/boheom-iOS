import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

class OnBoardingViewController: BaseVC<OnBoardingViewModel> {

    private let logoImageView = UIImageView(image: .boheomLogoTilted)

    private let headerLabel = UILabel().then {
        $0.boheomLabel(text: "보드게임\n모임을 찾아서.", font: .headerH1Bold)
        $0.numberOfLines = 0
    }

    private let subTitleLabel = UILabel().then {
        $0.boheomLabel(
            text: "보드게임을 하고 싶은데 할 사람이 없거나\n찾고 있으신가요? 고민하지 마세요!",
            font: .bodyB1Light,
            textColor: .gray600)
        $0.numberOfLines = 0
    }
    private let signupButton = BoheomButton(text: "시작하기", type: .fill)

    private let loginMarkLabel = UILabel().then {
        $0.boheomLabel(text: "이미 모험을 시작하셨다면, ", font: .captionC1Light)
        $0.numberOfLines = 0
    }
    private let loginButton = BoheomButton(
        text: "로그인",
        font: .captionC1Bold,
        textColor: .green500Main,
        type: .text
    )
    

    override func attribute() {
        view.backgroundColor = .white
        navigationController?.navigationBar.isHidden = true
    }

    override func addView() {
        view.addSubviews(
            logoImageView,
            headerLabel,
            subTitleLabel,
            signupButton,
            loginMarkLabel,
            loginButton
        )
    }

    override func layout() {
        logoImageView.snp.makeConstraints {
            $0.leading.equalTo(headerLabel.snp.trailing).inset(68 )
            $0.top.equalTo(headerLabel).offset(-10)
        }
        headerLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(23)
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(82)
        }
        subTitleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(23)
            $0.trailing.equalToSuperview().inset(16)
            $0.top.equalTo(headerLabel.snp.bottom).offset(17)
        }
        signupButton.snp.makeConstraints {
            $0.height.equalTo(44)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalTo(loginMarkLabel.snp.top).offset(-10)
        }
        loginMarkLabel.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.centerX.equalToSuperview().offset(-18)
        }
        loginButton.snp.makeConstraints {
            $0.centerY.equalTo(loginMarkLabel)
            $0.leading.equalTo(loginMarkLabel.snp.trailing)
        }
    }

    override func bind() {
        let input = OnBoardingViewModel.Input(
            signupSignal: signupButton.rx.tap.asObservable(),
            loginSignal: loginButton.rx.tap.asObservable()
        )
        let _ = viewModel.transform(input: input)
    }
}
