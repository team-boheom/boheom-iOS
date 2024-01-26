import UIKit
import SnapKit
import Then

class BohomePlaceholderView: UIView {
    private let iconImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
    }
    private let titleLabel = UILabel().then {
        $0.boheomLabel(font: .bodyB2SemiBold)
        $0.textAlignment = .center
        $0.numberOfLines = 0
    }
    private let subTitleLabel = UILabel().then {
        $0.boheomLabel(font: .captionC1Regular, textColor: .gray400)
        $0.textAlignment = .center
        $0.numberOfLines = 0
    }

    init(title: String?, subTitle: String?, icon: UIImage) {
        super.init(frame: .zero)
        titleLabel.text = title
        subTitleLabel.text = subTitle
        iconImageView.image = icon
        setLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setLayout() {
        addSubviews(iconImageView, titleLabel, subTitleLabel)
        iconImageView.snp.makeConstraints {
            $0.width.height.equalTo(120)
            $0.centerX.top.equalToSuperview()
        }
        titleLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(iconImageView.snp.bottom).offset(10)
        }
        subTitleLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(titleLabel.snp.bottom).offset(2)
        }
        self.snp.makeConstraints {
            $0.bottom.equalTo(subTitleLabel)
            $0.width.equalTo(205)
        }
    }
}
