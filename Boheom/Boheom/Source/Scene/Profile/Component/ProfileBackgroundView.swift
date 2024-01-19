import UIKit
import SnapKit
import Then

class ProfileBackgroundView: UIView {
    private let iconImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
    }

    init(backgroundImage: UIImage, backgroundColor: UIColor = .lightGreen300) {
        super.init(frame: .zero)
        iconImageView.image = backgroundImage
        self.backgroundColor = backgroundColor
        clipsToBounds = true
        addview()
        layout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func addview() {
        addSubview(iconImageView)
    }

    private func layout() {
        iconImageView.snp.makeConstraints {
            $0.width.height.equalTo(200)
            $0.trailing.equalToSuperview().offset(42)
            $0.top.equalToSuperview().offset(-33)
        }
    }
}
