import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

class BoheomDatePicker: UITextField {

    public let selectDate = BehaviorRelay<String?>(value: Date().toString("yyyy-MM-dd"))

    private let disposeBag: DisposeBag = .init()
    private let datePicker = UIDatePicker().then {
        $0.datePickerMode = .date
        $0.preferredDatePickerStyle = .wheels
        $0.locale = Locale(identifier: "ko-KR")
    }

    init(placeholder: String) {
        super.init(frame: .zero)
        setting(placeholder)
        bind()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension BoheomDatePicker {
    private func bind() {
        selectDate
            .bind(to: self.rx.text)
            .disposed(by: disposeBag)

        datePicker.rx.value
            .skip(1)
            .map { $0.toString("yyyy-MM-dd") }
            .bind(to: selectDate)
            .disposed(by: disposeBag)
    }

    private func setting(_ placeholder: String) {
        let padding = UIView(frame: .init(x: 0, y: 0, width: 12, height: 0))
        leftView = padding
        leftViewMode = .always
        inputView = datePicker
        tintColor = .clear
        layer.borderWidth = 1
        layer.borderColor = UIColor.gray100.cgColor
        layer.cornerRadius = 8
        font = .bodyB1Regular
        attributedPlaceholder = NSAttributedString(
            string: placeholder,
            attributes: [
                .font: UIFont.bodyB1Regular!,
                .foregroundColor: UIColor.gray500
            ]
        )
    }
}
