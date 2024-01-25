import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

class PostDetailViewController: BaseVC<PostDetailViewModel> {

    public var postID: String = ""
    private let fetchDetail = PublishRelay<String>()
    private let applyPost = PublishRelay<String>()
    private let cancelApplyPost = PublishRelay<String>()

    private let toastController = ToastViewController()

    private lazy var backButton = BoheomBackButton(navigationController)
    private let scrollView = UIScrollView().then {
        $0.showsVerticalScrollIndicator = false
        $0.contentInset = .init(top: 0, left: 0, bottom: 30, right: 0)
    }
    private let contentView = UIView().then {
        $0.backgroundColor = .white
    }

    private let headerView = PostDetailHeaderView()

    private let contentLabel = UILabel().then {
        $0.font = .bodyB1Regular
        $0.numberOfLines = 0
        $0.textAlignment = .left
        $0.lineBreakStrategy = .pushOut
    }

    private let applyButton = BoheomButton(text: "신청", font: .bodyB3Bold, type: .fill, cornerRadius: 4)
    private let applyCancelButton = BoheomButton(text: "취소", font: .bodyB3Bold, pointColor: .extraRed, type: .fill, cornerRadius: 4)

    override func viewWillAppear(_ animated: Bool) {
        fetchDetail.accept(postID)
    }

    override func attribute() {
        view.backgroundColor = .white
        addChild(toastController)
    }

    override func addView() {
        contentView.addSubviews(headerView, contentLabel, applyButton, applyCancelButton)
        scrollView.addSubview(contentView)
        view.addSubviews(scrollView, backButton, toastController.view)
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
            $0.bottom.equalTo(contentLabel).offset(50)
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
        applyCancelButton.snp.makeConstraints {
            $0.width.equalTo(60)
            $0.height.equalTo(32)
            $0.trailing.equalToSuperview().inset(16)
            $0.top.equalTo(contentLabel.snp.bottom).offset(26)
        }
    }

    override func bind() {
        let input = PostDetailViewModel.Input(
            fetchDetailSignal: fetchDetail.asObservable(),
            applySignal: applyPost.asObservable(),
            cancelApplySignal: cancelApplyPost.asObservable()
        )
        let output = viewModel.transform(input: input)

        applyButton.rx.tap
            .map { self.postID }
            .bind(to: applyPost)
            .disposed(by: disposeBag)

        applyCancelButton.rx.tap
            .map { self.postID }
            .bind(to: cancelApplyPost)
            .disposed(by: disposeBag)

        output.postDatailData.asObservable()
            .subscribe(with: self, onNext: { owner, data in
                owner.headerView.setup(with: data)
                owner.contentLabel.text = data.content
                owner.applyButton.isDisable = data.isMine
                owner.applyButton.isHidden = data.isApplied
                owner.applyCancelButton.isHidden = !data.isApplied
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
