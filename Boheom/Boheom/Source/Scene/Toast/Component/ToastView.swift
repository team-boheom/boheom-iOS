import UIKit
import SnapKit
import Then

class ToastView: UIView {
    private let iconImage = UIImageView().then {
        $0.image = .xCircleFill
        $0.contentMode = .scaleAspectFit
        $0.tintColor = .white
    }

    private let messageLabel = UILabel().then {
        $0.boheomLabel(font: .bodyB2Bold, textColor: .white)
    }

    init(message: String) {
        super.init(frame: .zero)
        messageLabel.text = message
        backgroundColor = .extraRed
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        addview()
        layout()
    }

    private func addview() {
        addSubviews(iconImage, messageLabel)
    }

    private func layout() {
        iconImage.snp.makeConstraints {
            $0.width.height.equalTo(20)
            $0.bottom.equalToSuperview().offset(-24)
            $0.leading.equalToSuperview().inset(25)
        }
        messageLabel.snp.makeConstraints {
            $0.centerY.equalTo(iconImage)
            $0.leading.equalTo(iconImage.snp.trailing).offset(10)
            $0.trailing.equalToSuperview().inset(16)
        }
        self.snp.makeConstraints {
            $0.width.equalToSuperview()
        }
    }
}
