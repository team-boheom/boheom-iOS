import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa
import Toasty

class LoginViewController: BaseVC<LoginViewModel> {

    private let headerLabel = LoginDynamicHeader()
    private let idTextField = BoheomTextField(title: "아이디", placeholder: "아이디를 입력하세요.")
    private let passwordTextField = BoheomTextField(title: "비밀번호", placeholder: "비밀번호를 입력하세요.", isSecure: true)

    private let loginButton = BoheomButton(text: "로그인", type: .fill)
    private let signupMarkLabel = UILabel().then {
        $0.boheomLabel(text: "아직 계정이 없으신가요? ", font: .captionC1Light)
    }
    private let signupButton = BoheomButton(text: "회원가입", font: .captionC1Bold, textColor: .green500Main, type: .text)

    override func attribute() {
        view.backgroundColor = .white
        navigationItem.hidesBackButton = true
    }

    override func bind() {
        let input = LoginViewModel.Input(
            signupSignal: signupButton.rx.tap.asObservable(),
            loginSignal: loginButton.rx.tap.asObservable(),
            idTextObservable: idTextField.textField.rx.text.orEmpty.asObservable(),
            passwordTextObservable: passwordTextField.textField.rx.text.orEmpty.asObservable()
        )
        let output = viewModel.transform(input: input)

        output.errorMessage.asObservable()
            .subscribe(with: self, onNext: { owner, message in
                let toastyView = BoheomToastyView(type: .error)
                toastyView.content = message
                owner.toastController.present(with: toastyView)
            })
            .disposed(by: disposeBag)
    }

    override func addView() {
        view.addSubviews(
            headerLabel,
            idTextField,
            passwordTextField,
            loginButton,
            signupMarkLabel,
            signupButton
        )
    }

    override func layout() {
        headerLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(82)
            $0.leading.equalToSuperview().inset(23)
        }
        idTextField.snp.makeConstraints {
            $0.top.equalTo(headerLabel.snp.bottom).offset(view.frame.height / (view.safeAreaInsets.bottom == 0 ? 15 : 10))
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        passwordTextField.snp.makeConstraints {
            $0.top.equalTo(idTextField.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        loginButton.snp.makeConstraints {
            $0.bottom.equalTo(signupMarkLabel.snp.top).offset(-10)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(44)
        }
        signupMarkLabel.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.centerX.equalToSuperview().offset(-18)
        }
        signupButton.snp.makeConstraints {
            $0.centerY.equalTo(signupMarkLabel)
            $0.leading.equalTo(signupMarkLabel.snp.trailing)
        }
    }
}
