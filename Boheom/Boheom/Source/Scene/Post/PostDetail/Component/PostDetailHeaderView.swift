import UIKit
import SnapKit
import Then

class PostDetailHeaderView: UIView {

    private let categoryLabel = UILabel().then {
        $0.boheomLabel(font: .captionC1Regular, textColor: .green600)
    }

    private let titleLabel = UILabel().then {
        $0.boheomLabel(font: .headerH3SemiBold)
    }

    private let nickNameLabel = UILabel().then {
        $0.boheomLabel(font: .captionC1SemiBold, textColor: .gray850)
    }

    private let dateLabel = UILabel().then {
        $0.boheomLabel(font: .captionC1Light, textColor: .gray500)
    }

    private let viewerCountLabel = IconLabel(iconImage: .eyeViewer)
    private let playerCountLabel = IconLabel(iconImage: .person)

    init() {
        super.init(frame: .zero)
        backgroundColor = .clear
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
            categoryLabel,
            titleLabel,
            nickNameLabel,
            dateLabel,
            viewerCountLabel,
            playerCountLabel
        )
    }

    private func layout() {
        categoryLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
        }
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(categoryLabel.snp.bottom).offset(6)
            $0.leading.trailing.equalToSuperview()
        }
        nickNameLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(10)
            $0.leading.equalToSuperview()
        }
        dateLabel.snp.makeConstraints {
            $0.top.equalTo(nickNameLabel)
            $0.leading.equalTo(nickNameLabel.snp.trailing).offset(2)
            $0.trailing.equalToSuperview()
        }
        viewerCountLabel.snp.makeConstraints {
            $0.top.equalTo(nickNameLabel.snp.bottom).offset(10)
            $0.leading.equalToSuperview()
        }
        playerCountLabel.snp.makeConstraints {
            $0.top.equalTo(viewerCountLabel)
            $0.leading.equalTo(viewerCountLabel.snp.trailing).offset(12)
        }
        self.snp.makeConstraints {
            $0.bottom.equalTo(viewerCountLabel)
        }
    }
}

extension PostDetailHeaderView {
    public func setup(
        category: String,
        title: String,
        nickName: String,
        date: String,
        viewer: String,
        player: String
    ) {
        categoryLabel.text = category
        titleLabel.text = title
        nickNameLabel.text = nickName
        dateLabel.text = "・ \(date)"
        viewerCountLabel.content = viewer
        playerCountLabel.content = player
    }
}
