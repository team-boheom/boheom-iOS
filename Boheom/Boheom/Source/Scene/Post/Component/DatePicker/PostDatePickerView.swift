import UIKit
import SnapKit
import Then

class PostDatePickerView: UIView {

    private let titleLabel = UILabel().then {
        $0.boheomLabel(text: "모집일", font: .bodyB2Regular, textColor: .gray500)
    }

    private let middleContentLabel = UILabel().then {
        $0.boheomLabel(text: "~", font: .headerH3Bold)
        $0.textAlignment = .center
    }

    let startInputDatePicker = BoheomDatePicker(placeholder: "시작일")
    let endInputDatePicker = BoheomDatePicker(placeholder: "마감일")

    init(title: String?) {
        super.init(frame: .zero)
        titleLabel.text = title
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        addSubviews(titleLabel, startInputDatePicker, endInputDatePicker, middleContentLabel)
        titleLabel.snp.makeConstraints {
            $0.leading.top.equalToSuperview()
        }
        startInputDatePicker.snp.makeConstraints {
            $0.width.equalTo(135)
            $0.height.equalTo(48)
            $0.leading.equalToSuperview()
            $0.top.equalTo(titleLabel.snp.bottom).offset(4)
        }
        endInputDatePicker.snp.makeConstraints {
            $0.width.equalTo(135)
            $0.height.equalTo(48)
            $0.trailing.equalToSuperview()
            $0.top.equalTo(startInputDatePicker)
        }
        middleContentLabel.snp.makeConstraints {
            $0.leading.equalTo(startInputDatePicker.snp.trailing)
            $0.trailing.equalTo(endInputDatePicker.snp.leading)
            $0.centerY.equalTo(startInputDatePicker)
        }
        self.snp.makeConstraints {
            $0.bottom.equalTo(startInputDatePicker)
        }
    }
}
