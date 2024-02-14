import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

class PostEditViewController: BaseVC<PostEditViewModel> {

    private lazy var backButton = BoheomBackButton(navigationController)

    private let scrollView = UIScrollView().then {
        $0.showsVerticalScrollIndicator = false
    }
    private let contentView = EditContentView().then {
        $0.backgroundColor = .white
    }

    private let headerView = SubContentHeader(headerText: "모집글 수정", subContentText: "잘못된 부분을 수정해보세요.")

    private let titleTextField = BoheomTextField(title: "제목", placeholder: "제목을 입력하세요.")
    private let contentTextView = BoheomTextView(title: "내용", placeholder: "내용을 입력하세요.")
    private let maxPlayerTextField = BoheomTextField(title: "모집 인원", placeholder: "최대 모집 인원 수를 입력하세요.", keyboardType: .asciiCapableNumberPad)
    private let recruitmentDatePicker = PostDatePickerView(title: "모집일")
    private let categoryTextField = CategoryInputTextField()
    private let editButton = BoheomButton(text: "수정", type: .fill)

    override func attribute() {
        view.backgroundColor = .white
        keyboardNotification()
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
        view.addSubviews(scrollView, backButton, editButton)
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
        editButton.snp.makeConstraints {
            $0.height.equalTo(44)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
        }
    }

    override func bind() {
        let input = PostEditViewModel.Input(
            titleTextSignal: titleTextField.textField.rx.text.orEmpty.asObservable(),
            contentTextSignal: contentTextView.inputTextView.rx.text.orEmpty.asObservable(),
            recruitmentTextSignal: maxPlayerTextField.textField.rx.text.orEmpty.asObservable(),
            startDayTextSignal: recruitmentDatePicker.startInputDatePicker.selectDate.asObservable(),
            endDayTextSignal: recruitmentDatePicker.endInputDatePicker.selectDate.asObservable(),
            tagListSignal: categoryTextField.categoryList.asObservable(),
            editButtonSignal: editButton.rx.tap.asObservable()
        )
        let output = viewModel.transform(input: input)

        output.writeButtonDisable.asObservable()
            .bind(to: editButton.rx.isDisable)
            .disposed(by: disposeBag)

        output.errorMessage.asObservable()
            .subscribe(with: self, onNext: { owner, message in
                let toastView = BoheomToastyView(type: .error)
                toastView.content = message
                owner.toastController.present(with: toastView)
            })
            .disposed(by: disposeBag)
    }

    private func keyboardNotification() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardControl(_:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardControl(_:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }

    @objc func keyboardControl(_ sender: Notification) {
        guard let userInfo = sender.userInfo else { return }
        guard let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        else { return }
        
        if sender.name == UIResponder.keyboardWillShowNotification {
            scrollView.contentInset = .init(
                top: 0,
                left: 0,
                bottom: keyboardFrame.height - view.safeAreaInsets.bottom,
                right: 0
            )
        } else {
            scrollView.contentInset = .init(top: 0, left: 0, bottom: 0, right: 0)
        }
    }
}

extension PostEditViewController {
    public func setEditData(originData: PostDetailEntity?) {
        guard let data = originData else { return }
        Observable.just(data.title)
            .bind(to: titleTextField.textField.rx.text)
            .disposed(by: disposeBag)
        Observable.just(data.content)
            .bind(to: contentTextView.inputTextView.rx.text)
            .disposed(by: disposeBag)
        Observable.just("\(data.recruitment)")
            .bind(to: maxPlayerTextField.textField.rx.text)
            .disposed(by: disposeBag)
        recruitmentDatePicker.startInputDatePicker.selectDate.accept(data.startDay)
        recruitmentDatePicker.endInputDatePicker.selectDate.accept(data.endDay)
        categoryTextField.categoryList.accept(data.tags)
    }
}
