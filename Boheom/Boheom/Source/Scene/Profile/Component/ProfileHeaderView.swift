import UIKit
import SnapKit
import Then
import Kingfisher

class ProfileHeaderView: UIView {

    private let profileImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.layer.cornerRadius = 15
        $0.backgroundColor = .gray100
        $0.clipsToBounds = true
    }

    private let nickNameLabel = UILabel().then {
        $0.boheomLabel(font: .headerH3Bold)
    }

    private let idLabel = UILabel().then {
        $0.boheomLabel(font: .bodyB2Bold, textColor: .gray400)
    }

    init() {
        super.init(frame: .zero)
        backgroundColor = .white
        layer.cornerRadius = 15
        setShadow()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        addview()
        layout()
    }

    private func addview() {
        addSubviews(
            profileImageView,
            nickNameLabel,
            idLabel
        )
    }

    private func layout() {
        profileImageView.snp.makeConstraints {
            $0.width.equalTo(90)
            $0.height.equalTo(120)
            $0.leading.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-16)
        }
        nickNameLabel.snp.makeConstraints {
            $0.leading.equalTo(profileImageView.snp.trailing).offset(20)
            $0.trailing.equalToSuperview().inset(20)
            $0.top.equalToSuperview().inset(10)
        }
        idLabel.snp.makeConstraints {
            $0.top.equalTo(nickNameLabel.snp.bottom).offset(2)
            $0.leading.trailing.equalTo(nickNameLabel)
        }
    }
}

extension ProfileHeaderView {
    public func setup(
        profileURL: URL?,
        nickName: String?,
        id: String?
    ) {
        profileImageView.kf.setImage(with: profileURL, placeholder: UIImage.defaltProfile)
        nickNameLabel.text = nickName
        idLabel.text = id
    }

    public func setProfileImageToUIIImage(image: UIImage?) {
        guard image != nil else { return }
        profileImageView.image = image
    }
}
