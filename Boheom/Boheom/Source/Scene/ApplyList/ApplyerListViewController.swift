import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

class ApplyerListViewController: BaseVC<ApplyerListViewModel> {

    private let fetchApplyerList = PublishRelay<String>()

    var postID: String = ""

    private let headerLabel = UILabel().then {
        $0.boheomLabel(text: "신청자 명단 📋", font: .headerH3SemiBold)
    }
    private let subHeaderLabel = UILabel().then {
        $0.boheomLabel(text: "어떤 신청자가 있는지 확인해보세요!", font: .captionC1Medium, textColor: .gray600)
    }
    private let placeholderView = BoheomPlaceholderView(
        title: "신청한 사람이 보이지 않아요..!",
        subTitle: "지금 빨리 신청하여 첫 신청자가 되어보세요.",
        icon: .thinkingFace
    ).then {
        $0.isHidden = true
    }

    private let applyListTableView = UITableView().then {
        $0.contentInset = .init(top: 15, left: 0, bottom: 0, right: 0)
        $0.showsVerticalScrollIndicator = false
        $0.bounces = false
        $0.backgroundColor = .clear
        $0.separatorStyle = .none
        $0.rowHeight = 48
        $0.register(ApplyListTableViewCell.self, forCellReuseIdentifier: ApplyListTableViewCell.identifier)
    }

    override func viewWillAppear(_ animated: Bool) {
        fetchApplyerList.accept(postID)
    }

    override func attribute() {
        view.backgroundColor = .white
        if let sheetPresentationController = sheetPresentationController {
            sheetPresentationController.detents = [.medium(), .large()]
            sheetPresentationController.prefersGrabberVisible = true
        }
    }

    override func addView() {
        view.addSubviews(
            headerLabel,
            subHeaderLabel,
            applyListTableView,
            placeholderView
        )
    }

    override func layout() {
        headerLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(38)
            $0.leading.equalToSuperview().inset(25)
        }
        subHeaderLabel.snp.makeConstraints {
            $0.top.equalTo(headerLabel.snp.bottom).offset(2)
            $0.leading.equalTo(headerLabel)
        }
        applyListTableView.snp.makeConstraints {
            $0.top.equalTo(subHeaderLabel.snp.bottom).offset(5)
            $0.leading.bottom.trailing.equalToSuperview()
        }
        placeholderView.snp.makeConstraints {
            $0.width.equalTo(205)
            $0.top.equalTo(subHeaderLabel.snp.bottom).offset(50)
            $0.centerX.equalToSuperview()
        }
    }

    override func bind() {
        let input = ApplyerListViewModel.Input(fetchApplyerListSignal: fetchApplyerList.asObservable())
        let output = viewModel.transform(input: input)

        output.applyerListData.asObservable()
            .map { $0.users }
            .bind(to: applyListTableView.rx.items(
                cellIdentifier: ApplyListTableViewCell.identifier,
                cellType: ApplyListTableViewCell.self
            )) { index, element, cell in
                cell.setup(imageURL: element.profile, name: element.nickname)
            }
            .disposed(by: disposeBag)

        output.applyerListData.asObservable()
            .map { !$0.users.isEmpty }
            .bind(to: placeholderView.rx.isHidden)
            .disposed(by: disposeBag)
    }
}
