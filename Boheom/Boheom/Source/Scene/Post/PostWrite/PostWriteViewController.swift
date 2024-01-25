import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

class PostWriteViewController: BaseVC<PostWriteViewModel> {

    private lazy var backButton = BoheomBackButton(navigationController)

    private let scrollView = UIScrollView().then {
        $0.showsVerticalScrollIndicator = false
    }
    private let contentView = UIView().then {
        $0.backgroundColor = .white
    }

    private let headerView = SubContentHeader(headerText: "모집글 작성", subContentText: "보드게임 같이 할 사람을 모아보세요!")

    private let titleTextField = BoheomTextField(title: "제목", placeholder: "제목을 입력하세요.")
    private let contentTextView = BoheomTextView(title: "내용", placeholder: "내용을 입력하세요.")
    private let maxPlayerTextField = BoheomTextField(title: "모집 인원", placeholder: "최대 모집 인원 수를 입력하세요.", keyboardType: .asciiCapableNumberPad)
    private let recruitmentDatePicker = PostDatePickerView(title: "모집일")
    private let categoryTextField = CategoryInputTextField()
    private let applyButton = BoheomButton(text: "작성", type: .fill)

    override func attribute() {
        view.backgroundColor = .white
    }

    override func addView() {
        contentView.addSubviews(
            headerView,
            titleTextField,
            contentTextView,
            maxPlayerTextField,
            recruitmentDatePicker,
            categoryTextField
        )
        scrollView.addSubview(contentView)
        view.addSubviews(scrollView, backButton, applyButton)
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
            $0.bottom.equalTo(categoryTextField).offset(80)
            $0.top.width.bottom.equalToSuperview()
        }
        headerView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(60)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        titleTextField.snp.makeConstraints {
            $0.top.equalTo(headerView.snp.bottom).offset(30)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        contentTextView.snp.makeConstraints {
            $0.top.equalTo(titleTextField.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        maxPlayerTextField.snp.makeConstraints {
            $0.top.equalTo(contentTextView.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        recruitmentDatePicker.snp.makeConstraints {
            $0.top.equalTo(maxPlayerTextField.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        categoryTextField.snp.makeConstraints {
            $0.top.equalTo(recruitmentDatePicker.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        applyButton.snp.makeConstraints {
            $0.height.equalTo(44)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
        }
    }
}