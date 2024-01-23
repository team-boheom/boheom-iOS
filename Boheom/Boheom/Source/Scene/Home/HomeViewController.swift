import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa
import Kingfisher

class HomeViewController: BaseVC<HomeViewModel> {

    private let fetchHome = PublishRelay<Void>()
    private let navigetToDetail = PublishRelay<String>()

    private let contentView = UIView().then {
        $0.backgroundColor = .gray50
    }
    private let homeScrollView = UIScrollView().then {
        $0.showsVerticalScrollIndicator = false
        $0.backgroundColor = .gray50
        $0.contentInset = .init(top: 0, left: 0, bottom: 30, right: 0)
    }

    private let headerLabelView = HomeHeaderView()

    private let profileButton = UIButton().then {
        $0.layer.cornerRadius = 20
        $0.layer.borderWidth = 0.5
        $0.layer.borderColor = UIColor.gray400.cgColor
        $0.clipsToBounds = true
    }

    private let recentPostHeader = BoheomListHeader(title: "최근 모집글 ⏰")
    private lazy var recentPostflowLayout = UICollectionViewFlowLayout().then {
        $0.scrollDirection = .horizontal
        $0.itemSize = .init(width: view.frame.width / 1.3, height: 168)
        $0.minimumLineSpacing = 10
        $0.minimumInteritemSpacing = 0
        $0.sectionInset = .init(top: 0, left: 16, bottom: 0, right: 16)
    }
    private lazy var recentPostCollectionView = UICollectionView(frame: .zero, collectionViewLayout: recentPostflowLayout).then {
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
    private let floatingButton = HomeFloatingButton()

    override func viewWillAppear(_ animated: Bool) {
        fetchHome.accept(())
    }

    override func attribute() {
        view.backgroundColor = .white
    }

    override func bind() {
        let input = HomeViewModel.Input(
            profileSignal: profileButton.rx.tap.asObservable(),
            writePostSignal: floatingButton.rx.tap.asObservable(),
            footerButtonSignal: footerButton.rx.tap.asObservable(),
            fetchHomeSignal: fetchHome.asObservable(),
            navigateDetailSignal: navigetToDetail.asObservable()
        )
        let output = viewModel.transform(input: input)

        homeScrollView.rx.didScroll
            .skip(1)
            .map {
                let target = self.homeScrollView
                return (target.contentOffset.y - 30) >= (target.contentSize.height - target.frame.size.height)
            }
            .bind(to: floatingButton.rx.isAnimaticHidden)
            .disposed(by: disposeBag)

        recentPostCollectionView.rx.itemSelected
            .map { index -> String in
                guard let cell = self.recentPostCollectionView.cellForItem(at: index) as? PostCollectionViewCell else { return ""}
                return cell.postId
            }
            .bind(to: navigetToDetail)
            .disposed(by: disposeBag)

        popularPostCollectionView.rx.itemSelected
            .map { index -> String in
                guard let cell = self.popularPostCollectionView.cellForItem(at: index) as? PostCollectionViewCell else { return ""}
                return cell.postId
            }
            .bind(to: navigetToDetail)
            .disposed(by: disposeBag)

        output.profileData.asObservable()
            .subscribe(with: self, onNext: { owner, date in
                owner.headerLabelView.userName = date.nickname
                owner.profileButton.kf.setImage(with: date.profile, for: .normal, placeholder: .defaltProfile)
            })
            .disposed(by: disposeBag)
        
        output.recentPostData.asObservable()
            .map { $0.posts }
            .bind(to: recentPostCollectionView.rx.items(
                cellIdentifier: PostCollectionViewCell.identifier,
                cellType: PostCollectionViewCell.self
            )) { index, element, cell in
                cell.setup(with: element)
            }
            .disposed(by: disposeBag)

        output.popularPostData.asObservable()
            .map { $0.posts.prefix(3) }
            .bind(to: popularPostCollectionView.rx.items(
                cellIdentifier: PostCollectionViewCell.identifier,
                cellType: PostCollectionViewCell.self
            )) { index, element, cell in
                cell.setup(with: element, isRanking: true, ranking: index + 1)
            }
            .disposed(by: disposeBag)
    }

    override func addView() {
        contentView.addSubviews(
            headerLabelView,
            profileButton,
            recentPostHeader,
            recentPostCollectionView,
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
        recentPostHeader.snp.makeConstraints {
            $0.top.equalTo(headerLabelView.snp.bottom).offset(26)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        recentPostCollectionView.snp.makeConstraints {
            $0.top.equalTo(recentPostHeader.snp.bottom).offset(10)
            $0.height.equalTo(168)
            $0.leading.trailing.equalToSuperview()
        }
        popularPostHeader.snp.makeConstraints {
            $0.top.equalTo(recentPostCollectionView.snp.bottom).offset(34)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        popularPostCollectionView.snp.updateConstraints {
            $0.top.equalTo(popularPostHeader.snp.bottom).offset(10)
            $0.height.equalTo(popularPostCollectionView.contentSize.height + 1)
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
