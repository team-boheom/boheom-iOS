import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

class PostDetailViewController: BaseVC<PostDetailViewModel> {

    private lazy var backButton = BoheomBackButton(navigationController)

    private let scrollView = UIScrollView().then {
        $0.showsVerticalScrollIndicator = false
        $0.contentInset = .init(top: 0, left: 0, bottom: 30, right: 0)
    }
    private let contentView = UIView().then {
        $0.backgroundColor = .white
    }

    private let headerView = PostDetailHeaderView().then {
        $0.setup(category: "#뱅 #4인 #모여라 #퍼즐", title: "같이 뱅 하실래요?", nickName: "닉네임뭐하지", date: "2024년 1월 1일", viewer: "23", player: "1/4")
    }

    private let contentLabel = UILabel().then {
        $0.font = .bodyB1Regular
        $0.numberOfLines = 0
        $0.textAlignment = .left
        $0.lineBreakStrategy = .pushOut
        $0.text = "같이 뱅 할 사람 모여라 블라블라블라블라블라블라블라블라블라블라블라블라블라블라블라블라블라블라블라블라블라블라블라블라블라블라블라블라블라블라블라블라블라블라블라블라블라블라\n블라블라블라블라블라블라블라블라블라블라블라블라블라블라블라블라블라블라블라블라블라블라블라블라블라블라블라블라블라블라블라블라블라블라블라같이 뱅 할 사람 모여라"
    }

    private let applyButton = BoheomButton(text: "신청", font: .bodyB3Bold, type: .fill, cornerRadius: 4)

    override func attribute() {
        view.backgroundColor = .white
    }

    override func addView() {
        contentView.addSubviews(headerView, contentLabel, applyButton)
        scrollView.addSubview(contentView)
        view.addSubviews(scrollView, backButton)
    }

    override func layout() {
        backButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.leading.equalToSuperview().inset(16)
        }
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        contentView.snp.makeConstraints {
            $0.top.width.equalToSuperview()
            $0.bottom.equalTo(applyButton)
            $0.bottom.equalToSuperview()
        }
        headerView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(70)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        contentLabel.snp.makeConstraints {
            $0.top.equalTo(headerView.snp.bottom).offset(26)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        applyButton.snp.makeConstraints {
            $0.width.equalTo(60)
            $0.height.equalTo(32)
            $0.trailing.equalToSuperview().inset(16)
            $0.top.equalTo(contentLabel.snp.bottom).offset(26)
        }
    }
}
