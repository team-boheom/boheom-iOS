import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

class HomeViewController: BaseVC<HomeViewModel> {

    private let contentView = UIView().then {
        $0.backgroundColor = .gray50
    }
    private let homeScrollView = UIScrollView().then {
        $0.showsVerticalScrollIndicator = false
        $0.backgroundColor = .gray50
        $0.contentInset = .init(top: 0, left: 0, bottom: 30, right: 0)
    }

    private let headerLabelView = HomeHeaderView().then {
        $0.userName = "포도맛포도"
    }

    private let profileButton = UIButton().then {
        $0.layer.cornerRadius = 20
        $0.layer.borderWidth = 0.5
        $0.layer.borderColor = UIColor.gray400.cgColor
        $0.clipsToBounds = true
        $0.setImage(.checkmark, for: .normal)
    }

    private let newlyPostHeader = BoheomListHeader(title: "최근 모집글 ⏰")
    private lazy var newlyPostflowLayout = UICollectionViewFlowLayout().then {
        $0.scrollDirection = .horizontal
        $0.itemSize = .init(width: view.frame.width / 1.3, height: 168)
        $0.minimumLineSpacing = 10
        $0.minimumInteritemSpacing = 0
        $0.sectionInset = .init(top: 0, left: 16, bottom: 0, right: 16)
    }
    private lazy var newlyPostCollectionView = UICollectionView(frame: .zero, collectionViewLayout: newlyPostflowLayout).then {
        $0.backgroundColor = .clear
        $0.showsHorizontalScrollIndicator = false
        $0.clipsToBounds = false
        $0.register(PostCollectionViewCell.self, forCellWithReuseIdentifier: PostCollectionViewCell.identifier)
        $0.setShadow()
    }

    private let popularPostHeader = BoheomListHeader(title: "인기 모집글 🥳")
    private lazy var popularPostflowLayout = UICollectionViewFlowLayout().then {
        $0.scrollDirection = .vertical
        $0.itemSize = .init(width: view.frame.width - 32, height: 168)
        $0.minimumLineSpacing = 10
        $0.minimumInteritemSpacing = 0
    }
    private lazy var popularPostCollectionView = UICollectionView(frame: .zero, collectionViewLayout: popularPostflowLayout).then {
        $0.backgroundColor = .clear
        $0.showsVerticalScrollIndicator = false
        $0.isScrollEnabled = false
        $0.clipsToBounds = false
        $0.register(PostCollectionViewCell.self, forCellWithReuseIdentifier: PostCollectionViewCell.identifier)
        $0.setShadow()
    }

    private let footerButton = HomeFooterButton()

    private let floatingButton = UIButton(type: .system).then {
        $0.backgroundColor = .green400
        $0.setImage(.plus, for: .normal)
        $0.layer.cornerRadius = 10
        $0.tintColor = .white
        $0.setShadow()
    }

    override func attribute() {
        view.backgroundColor = .yellow
        newlyPostCollectionView.delegate = self
        newlyPostCollectionView.dataSource = self
        popularPostCollectionView.delegate = self
        popularPostCollectionView.dataSource = self
        homeScrollView.delegate = self
    }

    override func bind() {
        let input = HomeViewModel.Input(profileSignal: profileButton.rx.tap.asObservable())
        let _ = viewModel.transform(input: input)
    }

    override func addView() {
        contentView.addSubviews(
            headerLabelView,
            profileButton,
            newlyPostHeader,
            newlyPostCollectionView,
            popularPostHeader,
            popularPostCollectionView,
            footerButton
        )
        homeScrollView.addSubview(contentView)
        view.addSubviews(homeScrollView, floatingButton)
    }

    override func layout() {
        homeScrollView.snp.makeConstraints {
            $0.top.width.height.equalToSuperview()
        }
        contentView.snp.makeConstraints {
            $0.top.width.equalToSuperview()
            $0.bottom.greaterThanOrEqualTo(footerButton)
            $0.bottom.equalToSuperview()
        }
        headerLabelView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(50)
            $0.leading.equalToSuperview().inset(16)
            $0.trailing.equalTo(profileButton.snp.leading).offset(-10)
        }
        profileButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(40)
            $0.width.height.equalTo(40)
            $0.trailing.equalToSuperview().inset(16)
        }
        newlyPostHeader.snp.makeConstraints {
            $0.top.equalTo(headerLabelView.snp.bottom).offset(26)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        newlyPostCollectionView.snp.makeConstraints {
            $0.top.equalTo(newlyPostHeader.snp.bottom).offset(10)
            $0.height.equalTo(168)
            $0.leading.trailing.equalToSuperview()
        }
        popularPostHeader.snp.makeConstraints {
            $0.top.equalTo(newlyPostCollectionView.snp.bottom).offset(34)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        popularPostCollectionView.snp.updateConstraints {
            $0.top.equalTo(popularPostHeader.snp.bottom).offset(10)
            $0.height.equalTo(popularPostCollectionView.contentSize.height)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        footerButton.snp.makeConstraints {
            $0.top.equalTo(popularPostCollectionView.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        floatingButton.snp.makeConstraints {
            $0.width.height.equalTo(50)
            $0.trailing.equalToSuperview().inset(12)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-22)
        }
    }
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PostCollectionViewCell.identifier, for: indexPath) as? PostCollectionViewCell else { return UICollectionViewCell() }
        cell.setup(category: "#뱅 #4인 #모여라 #퍼즐", title: "같이 뱅 하실래요?", content: "같이 뱅 할사람 모여라 블라블라블라블라블라블라블라블라블라블라")
        return cell
    }
}

extension HomeViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (scrollView.contentOffset.y - 30) >= (scrollView.contentSize.height - scrollView.frame.size.height) {
            floatingButton.isHidden = true
        } else {
            floatingButton.isHidden = false
        }
    }
}
