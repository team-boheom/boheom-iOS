import UIKit
import SnapKit
import Then

class IconLabel: UIView {

    public var content: String {
        set { contentLabel.text = newValue }
        get { contentLabel.text ?? "" }
    }

    private let iconView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.tintColor = .gray500
    }

    private let contentLabel = UILabel().then {
        $0.font = .captionC1Regular
        $0.textColor = .gray500
    }

    init(iconImage: UIImage? = nil, text: String? = nil) {
        super.init(frame: .zero)
        iconView.image = iconImage
        contentLabel.text = text
        addview()
        layout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func addview() {
        addSubviews(iconView, contentLabel)
    }

    private func layout() {
        iconView.snp.makeConstraints {
            $0.top.leading.equalToSuperview()
            $0.width.height.equalTo(16)
        }
        contentLabel.snp.makeConstraints {
            $0.leading.equalTo(iconView.snp.trailing).offset(6)
            $0.centerY.equalToSuperview()
        }
        self.snp.makeConstraints {
            $0.trailing.equalTo(contentLabel)
            $0.bottom.equalTo(iconView)
        }
    }
}
