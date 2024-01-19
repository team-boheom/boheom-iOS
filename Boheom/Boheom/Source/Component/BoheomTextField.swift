import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

public class BoheomTextField: UIView {

    private let disposeBag: DisposeBag = .init()

    private var isSecure: Bool {
        set {
            secureButton.isHidden = !newValue
            inputTextField.isSecureTextEntry = newValue
            secureToggle = newValue
        }
        get { return secureToggle }
    }

    private var secureToggle: Bool = false {
        didSet {
            inputTextField.isSecureTextEntry = secureToggle
            secureButton.setImage(secureToggle ? .eyeOff : .eyeOn , for: .normal)
        }
    }

    private let textFieldStackView = UIStackView().then {
        $0.axis = .vertical
        $0.alignment = .leading
        $0.spacing = 4
    }

    private let titleLabel = UILabel().then {
        $0.font = .bodyB2Regular
        $0.textColor = .gray500
    }

    private let inputTextField = UITextField().then {
        $0.backgroundColor = .white
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.gray100.cgColor
        $0.layer.cornerRadius = 8
        $0.font = .bodyB1Regular
        $0.leftViewMode = .always
        $0.rightViewMode = .always
    }

    private let secureButton = UIButton(type: .system).then {
        $0.tintColor = .gray500
    }

    init(title: String?, placeholder: String, isSecure: Bool = false) {
        super.init(frame: .zero)
        self.isSecure = isSecure

        titleLabel.text = title
        settingPlaceholder(placeholder)
        bind()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func layoutSubviews() {
        addView()
        layout()
    }

    private func addView() {
        inputTextField.addSubview(secureButton)
        [titleLabel, inputTextField].forEach {
            textFieldStackView.addArrangedSubview($0)
        }
        addSubview(textFieldStackView)
    }

    private func layout() {
        let leftPadding = UIView(frame: .init(x: 0, y: 0, width: 12, height: 0))
        let rightPadding = UIView(frame: .init(x: 0, y: 0, width: isSecure ? 48 : 12, height: 0))
        inputTextField.leftView = leftPadding
        inputTextField.rightView = rightPadding
        
        titleLabel.snp.makeConstraints {
            $0.width.equalToSuperview()
        }
        textFieldStackView.snp.makeConstraints {
            $0.top.width.equalToSuperview()
        }
        inputTextField.snp.makeConstraints {
            $0.height.equalTo(48)
            $0.leading.trailing.equalToSuperview()
        }
        secureButton.snp.makeConstraints {
            $0.width.height.equalTo(24)
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(12)
        }
        self.snp.makeConstraints {
            $0.bottom.equalTo(textFieldStackView)
        }
    }

    private func bind() {
        secureButton.rx.tap
            .bind(with: self, onNext: { owner, _ in owner.secureToggle.toggle() })
            .disposed(by: disposeBag)
    }

    private func settingPlaceholder(_ content: String) {
        inputTextField.attributedPlaceholder = NSAttributedString(
            string: content,
            attributes: [
                NSAttributedString.Key.font: UIFont.bodyB1Regular!,
                NSAttributedString.Key.foregroundColor: UIColor.gray500
            ]
        )
    }
}
