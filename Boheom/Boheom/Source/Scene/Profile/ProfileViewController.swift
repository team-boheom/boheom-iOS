import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa
import PhotosUI

class ProfileViewController: BaseVC<ProfileViewModel> {

    private let fetchProfile = PublishRelay<Void>()
    private let navigetToDetail = PublishRelay<String>()
    private let applyPost = PublishRelay<String>()
    private let cancelApplyPost = PublishRelay<String>()
    private let uploadProfileImage = PublishRelay<Data>()

    private let toastController = ToastViewController()
    private let photoPickerManager = ProfileImagePickerManager()

    private lazy var backButton = BoheomBackButton(self.navigationController)
    private let editProfileButton = UIButton(type: .system).then {
        $0.backgroundColor = .white
        $0.setImage(.pencil, for: .normal)
        $0.tintColor = .gray700
        $0.layer.cornerRadius = 15
        $0.setShadow()
    }

    private let scrollView = UIScrollView().then {
        $0.contentInset = .init(top: 0, left: 0, bottom: 0, right: 0)
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
    private let myPostPlaceholder = BoheomPlaceholderView(
        title: "이런, 아무런 모집글도 작성하지 않았어요!",
        subTitle: "모집글을 작성하여 원하는 사람들을 모아보세요.",
        icon: .faceWithPeekingEye
    ).then {
        $0.isHidden = true
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
    private let myApplyPostPlaceholder = BoheomPlaceholderView(
        title: "신청한 모집글이 없는것 같네요..!",
        subTitle: "빨리 원하는 모집글을 찾아 신청해보세요.",
        icon: .faceWithOpenEyesAndHandOverMouth
    ).then {
        $0.isHidden = true
    }

    override func viewWillAppear(_ animated: Bool) {
        fetchProfile.accept(())
    }

    override func attribute() {
        view.backgroundColor = .gray50
        addChild(toastController)
    }

    override func addView() {
        contentView.addSubviews(
            headerView,
            myPostHeaderView,
            myPostCollectionView,
            myApplyPostHeaderView,
            myApplyPostCollectionView,
            myPostPlaceholder,
            myApplyPostPlaceholder
        )
        scrollContentView.addSubview(contentView)
        scrollView.addSubview(scrollContentView)
        view.addSubviews(
            backgroundView,
            scrollView,
            backButton,
            editProfileButton,
            toastController.view
        )
    }

    override func layout() {
        backButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            $0.leading.equalToSuperview().inset(16)
        }
        editProfileButton.snp.makeConstraints {
            $0.width.height.equalTo(30)
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            $0.trailing.equalToSuperview().inset(16)
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
            $0.bottom.greaterThanOrEqualTo(myApplyPostCollectionView)
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
        myPostPlaceholder.snp.makeConstraints {
            $0.top.equalTo(myPostHeaderView.snp.bottom).offset(14)
            $0.centerX.equalToSuperview()
        }
        myApplyPostHeaderView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.top.equalTo(myPostCollectionView.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        myApplyPostCollectionView.snp.makeConstraints {
            $0.top.equalTo(myApplyPostHeaderView.snp.bottom).offset(10)
            $0.height.equalTo(168)
            $0.leading.trailing.equalToSuperview()
        }
        myApplyPostPlaceholder.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.top.equalTo(myApplyPostHeaderView.snp.bottom).offset(14)
            $0.centerX.equalToSuperview()
        }
    }

    override func bind() {
        let input = ProfileViewModel.Input(
            fetchProfileSignal: fetchProfile.asObservable(),
            applySignal: applyPost.asObservable(),
            cancelApplySignal: cancelApplyPost.asObservable(),
            navigateDetailSignal: navigetToDetail.asObservable(),
            uploadImageSignal: uploadProfileImage.asObservable()
        )
        let output = viewModel.transform(input: input)

        editProfileButton.rx.tap
            .bind(onNext: presentPhotoPicker)
            .disposed(by: disposeBag)

        output.myPostData.asObservable()
            .map { $0.posts }
            .bind(to: myPostCollectionView.rx.items(
                cellIdentifier: PostCollectionViewCell.identifier,
                cellType: PostCollectionViewCell.self
            )) { index, element, cell in
                cell.setup(with: element)
                cell.cellDelegate = self
            }
            .disposed(by: disposeBag)

        output.myPostData.asObservable()
            .map { !$0.posts.isEmpty }
            .bind(to: myPostPlaceholder.rx.isHidden)
            .disposed(by: disposeBag)

        output.applyPostData.asObservable()
            .map { $0.posts }
            .bind(to: myApplyPostCollectionView.rx.items(
                cellIdentifier: PostCollectionViewCell.identifier,
                cellType: PostCollectionViewCell.self
            )) { index, element, cell in
                cell.setup(with: element)
                cell.cellDelegate = self
            }
            .disposed(by: disposeBag)

        output.applyPostData.asObservable()
            .map { !$0.posts.isEmpty }
            .bind(to: myApplyPostPlaceholder.rx.isHidden)
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

        output.errorMessage.asObservable()
            .subscribe(with: self, onNext: { owner, message in
                owner.toastController.presentToast(with: message, type: .error)
            })
            .disposed(by: disposeBag)

        output.successMessage.asObservable()
            .subscribe(with: self, onNext: { owner, message in
                owner.toastController.presentToast(with: message, type: .succees)
            })
            .disposed(by: disposeBag)
    }
}

extension ProfileViewController {
    private func presentPhotoPicker() {
        let photoPicker = photoPickerManager.makeImagePicker()
        photoPicker.delegate = self
        present(photoPicker, animated: true)
    }
}

extension ProfileViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)

        photoPickerManager.setSelectImage(item: results.map(\.itemProvider).first)

        Task {
            let image = await photoPickerManager.toUIImage()
            headerView.setProfileImageToUIIImage(image: image)

            guard let data = await photoPickerManager.toData() else { return }
            uploadProfileImage.accept(data)
        }
    }
}

extension ProfileViewController: PostCollectionViewCellDelegate {
    func applyButtonDidTap(postID: String) {
        applyPost.accept(postID)
    }

    func cancelApplyButtonDidTap(postID: String) {
        cancelApplyPost.accept(postID)
    }
}
