import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

class ProfileViewController: BaseVC<ProfileViewModel> {

    private let fetchProfile = PublishRelay<Void>()
    private let navigetToDetail = PublishRelay<String>()

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
    private lazy var mypostflowLayout = UICollectionViewFlowLayout().then {
        $0.scrollDirection = .horizontal
        $0.itemSize = .init(width: view.frame.width / 1.3, height: 168)
        $0.minimumLineSpacing = 10
        $0.minimumInteritemSpacing = 0
        $0.sectionInset = .init(top: 0, left: 16, bottom: 0, right: 16)
    }
    private lazy var myPostCollectionView = UICollectionView(frame: .zero, collectionViewLayout: mypostflowLayout).then {
        $0.backgroundColor = .clear
        $0.showsHorizontalScrollIndicator = false
        $0.clipsToBounds = false
        $0.register(PostCollectionViewCell.self, forCellWithReuseIdentifier: PostCollectionViewCell.identifier)
        $0.setShadow()
    }

    private let myApplyPostHeaderView = BoheomListHeader(title: "내가 신청한 모집글 🎮", isShowNavigate: false)
    private lazy var myApplyflowLayout = UICollectionViewFlowLayout().then {
        $0.scrollDirection = .horizontal
        $0.itemSize = .init(width: view.frame.width / 1.3, height: 168)
        $0.minimumLineSpacing = 10
        $0.minimumInteritemSpacing = 0
        $0.sectionInset = .init(top: 0, left: 16, bottom: 0, right: 16)
    }
    private lazy var myApplyPostCollectionView = UICollectionView(frame: .zero, collectionViewLayout: myApplyflowLayout).then {
        $0.backgroundColor = .clear
        $0.showsHorizontalScrollIndicator = false
        $0.clipsToBounds = false
        $0.register(PostCollectionViewCell.self, forCellWithReuseIdentifier: PostCollectionViewCell.identifier)
        $0.setShadow()
    }

    override func viewWillAppear(_ animated: Bool) {
        fetchProfile.accept(())
    }

    override func attribute() {
        view.backgroundColor = .gray50
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
            $0.height.equalTo(168)
            $0.top.equalTo(myPostHeaderView.snp.bottom).offset(10)
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

    // TODO: 이 무슨 ㅈ같은 버그 왜나는지 찾기;
    override func bind() {
        let input = ProfileViewModel.Input(
            fetchProfileSignal: fetchProfile.asObservable(),
            navigateDetailSignal: navigetToDetail.asObservable()
        )
        let output = viewModel.transform(input: input)

        output.myPostData.asObservable()
            .map { $0.posts }
            .bind(to: myPostCollectionView.rx.items(
                cellIdentifier: PostCollectionViewCell.identifier,
                cellType: PostCollectionViewCell.self
            )) { index, element, cell in
                cell.setup(with: element)
            }
            .disposed(by: disposeBag)

        output.applyPostData.asObservable()
            .map { $0.posts }
            .bind(to: myApplyPostCollectionView.rx.items(
                cellIdentifier: PostCollectionViewCell.identifier,
                cellType: PostCollectionViewCell.self
            )) { index, element, cell in
                cell.setup(with: element)
            }
            .disposed(by: disposeBag)

        myPostCollectionView.rx.itemSelected
            .map { index -> String in
                guard let cell = self.myPostCollectionView.cellForItem(at: index) as? PostCollectionViewCell else { return "" }
                return cell.postId
            }
            .bind(to: navigetToDetail)
            .disposed(by: disposeBag)

        myApplyPostCollectionView.rx.itemSelected
            .map { index -> String in
                guard let cell = self.myApplyPostCollectionView.cellForItem(at: index) as? PostCollectionViewCell else { return "" }
                return cell.postId
            }
            .bind(to: navigetToDetail)
            .disposed(by: disposeBag)

        output.profileData.asObservable()
            .subscribe(with: self, onNext: { owner, data in
                owner.headerView.setup(
                    profileURL: data.profile,
                    nickName: data.nickname,
                    id: data.accountId
                )
            })
            .disposed(by: disposeBag)
    }
}
