import UIKit
import SnapKit
import Then
import Kingfisher

class ApplyListTableViewCell: UITableViewCell {

    static let identifier: String = "ApplyListTableViewCell"

    private let profileImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.backgroundColor = .gray150
        $0.layer.cornerRadius = 20
    }

    private let nameLabel = UILabel().then {
        $0.boheomLabel(font: .bodyB1Regular)
    }

    public func setup(imageURL: URL?, name: String) {
        profileImageView.kf.setImage(with: imageURL, placeholder: UIImage.defaltProfile)
        nameLabel.text = name
        selectionStyle = .none
        setupLayout()
    }

    private func setupLayout() {
        addSubviews(profileImageView, nameLabel)
        profileImageView.snp.makeConstraints {
            $0.width.height.equalTo(40)
            $0.leading.equalToSuperview().inset(25)
            $0.centerY.equalToSuperview()
        }
        nameLabel.snp.makeConstraints {
            $0.leading.equalTo(profileImageView.snp.trailing).offset(16)
            $0.trailing.equalToSuperview().inset(25)
            $0.centerY.equalToSuperview()
        }
    }
}
