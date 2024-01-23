import UIKit
import SnapKit
import Then

class PostCollectionViewCell: UICollectionViewCell {

    static let identifier: String = "PostCollectionViewCell"

    public var postId: String = ""

    private let categoryLabel = UILabel().then {
        $0.boheomLabel(font: .captionC1Regular, textColor: .green600)
    }

    private let titleLabel = UILabel().then {
        $0.boheomLabel(font: .headerH3SemiBold)
    }

    private let contentLabel = UILabel().then {
        $0.boheomLabel(font: .bodyB3Regular, textColor: .gray500)
        $0.numberOfLines = 2
    }

    private let viewerCountLabel = IconLabel(iconImage: .eyeViewer)
    private let playerCountLabel = IconLabel(iconImage: .person)

    private let rankBackView = UIView().then {
        $0.backgroundColor = .green150
        $0.layer.cornerRadius = 40
    }
    private let rankLabel = UILabel().then {
        $0.font = .headerH1SemiBold
        $0.textColor = .green700
        $0.textAlignment = .center
    }

    private let applyButton = BoheomButton(text: "신청", font: .bodyB3Bold, type: .fill, cornerRadius: 4)

    public func setup(
        with postData: PostEntity,
        isRanking: Bool = false,
        ranking: Int = 0
    ) {
        categoryLabel.text = toCategoryString(postData.tags)
        titleLabel.text = postData.title
        contentLabel.text = postData.content
        viewerCountLabel.content = "\(postData.viewerCount)"
        playerCountLabel.content = "\(postData.applyCount)/\(postData.recruitment)"
        postId = postData.id
        backgroundColor = .white
        layer.cornerRadius = 8
        clipsToBounds = true
        rankBackView.isHidden = !isRanking
        rankLabel.isHidden = !isRanking
        settingRanking(isRnaking: isRanking, rank: ranking)
    }

    override func layoutSubviews() {
        addview()
        layout()
    }

    private func addview() {
        addSubviews(
            categoryLabel,
            titleLabel,
            contentLabel,
            viewerCountLabel,
            playerCountLabel,
            applyButton,
            rankBackView,
            rankLabel
        )
    }

    private func layout() {
        categoryLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(20)
            $0.leading.trailing.equalToSuperview().inset(24)
        }
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(categoryLabel.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(24)
        }
        contentLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview().inset(24)
        }
        viewerCountLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(24)
            $0.bottom.equalToSuperview().inset(19)
        }
        playerCountLabel.snp.makeConstraints {
            $0.leading.equalTo(viewerCountLabel.snp.trailing).offset(12)
            $0.bottom.equalTo(viewerCountLabel)
        }
        applyButton.snp.makeConstraints {
            $0.width.equalTo(60)
            $0.height.equalTo(32)
            $0.trailing.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().inset(17)
        }
        rankBackView.snp.makeConstraints {
            $0.width.height.equalTo(80)
            $0.trailing.equalToSuperview().offset(25)
            $0.top.equalToSuperview().offset(-24)
        }
        rankLabel.snp.makeConstraints {
            $0.width.height.equalTo(30)
            $0.top.trailing.equalToSuperview().inset(8)
        }
    }
}

extension PostCollectionViewCell {
    private func toCategoryString(_ arr: [String]) -> String {
        guard var categoryString = arr.first else { return "" }
        for i in 1..<arr.count { categoryString = categoryString + " \(arr[i])" }
        return categoryString
    }

    private func settingRanking(isRnaking: Bool, rank: Int) {
        guard isRnaking else { return }
        let rankMark: String
        switch rank {
        case 1: rankMark = "🥇"
        case 2: rankMark = "🥈"
        case 3: rankMark = "🥉"
        default: rankMark = "\(rank)"
        }
        rankLabel.text = rankMark
    }
}
