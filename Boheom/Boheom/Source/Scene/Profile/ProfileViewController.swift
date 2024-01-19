import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

class ProfileViewController: BaseVC<ProfileViewModel> {

    private lazy var postflowLayout = UICollectionViewFlowLayout().then {
        $0.scrollDirection = .horizontal
        $0.itemSize = .init(width: view.frame.width / 1.3, height: 168)
        $0.minimumLineSpacing = 10
        $0.minimumInteritemSpacing = 0
        $0.sectionInset = .init(top: 0, left: 16, bottom: 0, right: 16)
    }

    private lazy var backButton = BoheomBackButton(self.navigationController)

    private let scrollView = UIScrollView().then {
        $0.backgroundColor = .clear
        $0.showsVerticalScrollIndicator = false
    }
    private let scrollContentView = UIView().then {
        $0.backgroundColor = .clear
    }
    private let contentView = UIView().then {
        $0.backgroundColor = .gray50
    }

    private let backgroundView = ProfileBackgroundView(backgroundImage: .gameDie)
    private let headerView = ProfileHeaderView()

    private let myPostHeaderView = BoheomListHeader(title: "내가 작성한 모집글 ✍️", isShowNavigate: false)
    private lazy var myPostCollectionView = UICollectionView(frame: .zero, collectionViewLayout: postflowLayout).then {
        $0.backgroundColor = .clear
        $0.showsHorizontalScrollIndicator = false
        $0.clipsToBounds = false
        $0.register(PostCollectionViewCell.self, forCellWithReuseIdentifier: PostCollectionViewCell.identifier)
        $0.setShadow()
    }

    private let myApplyPostHeaderView = BoheomListHeader(title: "내가 신청한 모집글 🎮", isShowNavigate: false)
    private lazy var myApplyPostCollectionView = UICollectionView(frame: .zero, collectionViewLayout: postflowLayout).then {
        $0.backgroundColor = .clear
        $0.showsHorizontalScrollIndicator = false
        $0.clipsToBounds = false
        $0.register(PostCollectionViewCell.self, forCellWithReuseIdentifier: PostCollectionViewCell.identifier)
        $0.setShadow()
    }

    override func attribute() {
        myPostCollectionView.delegate = self
        myPostCollectionView.dataSource = self
        myApplyPostCollectionView.delegate = self
        myApplyPostCollectionView.dataSource = self
        view.backgroundColor = .gray50
        headerView.setup(
            profileURL: "https://upload.wikimedia.org/wikipedia/commons/thumb/c/c4/PM5544_with_non-PAL_signals.png/300px-PM5544_with_non-PAL_signals.png",
            nickName: "포도맛포도",
            id: "bjcho1503"
        )
    }

    override func addView() {
        contentView.addSubviews(
            headerView,
            myPostHeaderView,
            myPostCollectionView,
            myApplyPostHeaderView,
            myApplyPostCollectionView
        )
        scrollContentView.addSubview(contentView)
        scrollView.addSubview(scrollContentView)
        view.addSubviews(
            backgroundView,
            scrollView,
            backButton
        )
    }

    override func layout() {
        backButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            $0.leading.equalToSuperview().inset(16)
        }
        backgroundView.snp.makeConstraints {
            $0.top.width.equalToSuperview()
            $0.height.equalToSuperview()
        }
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        scrollContentView.snp.makeConstraints {
            $0.top.width.equalToSuperview()
            $0.bottom.greaterThanOrEqualTo(myApplyPostCollectionView).offset(30)
            $0.bottom.equalToSuperview()
        }
        contentView.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.top.equalToSuperview().offset(view.frame.height / 3.5)
            $0.bottom.equalTo(view).offset(view.frame.height)
        }
        headerView.snp.makeConstraints {
            $0.height.equalTo(98)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.centerY.equalTo(contentView.snp.top)
        }
        myPostHeaderView.snp.makeConstraints {
            $0.top.equalTo(headerView.snp.bottom).offset(34)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        myPostCollectionView.snp.makeConstraints {
            $0.top.equalTo(myPostHeaderView.snp.bottom).offset(10)
            $0.height.equalTo(168)
            $0.leading.trailing.equalToSuperview()
        }
        myApplyPostHeaderView.snp.makeConstraints {
            $0.top.equalTo(myPostCollectionView.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        myApplyPostCollectionView.snp.makeConstraints {
            $0.top.equalTo(myApplyPostHeaderView.snp.bottom).offset(10)
            $0.height.equalTo(168)
            $0.leading.trailing.equalToSuperview()
        }
    }
}

extension ProfileViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PostCollectionViewCell.identifier, for: indexPath) as? PostCollectionViewCell else { return UICollectionViewCell() }
        cell.setup(category: "#뱅 #4인 #모여라 #퍼즐", title: "같이 뱅 하실래요?", content: "같이 뱅 할사람 모여라 블라블라블라블라블라블라블라블라블라블라")
        return cell
    }
}
