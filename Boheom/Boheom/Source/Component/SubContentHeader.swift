import UIKit
import SnapKit
import Then

class SubContentHeader: UIView {

    public var headerText: String {
        set { headerLabel.text = newValue }
        get { return headerLabel.text ?? "" }
    }

    public var contentText: String {
        set { subContentLabel.text = newValue }
        get { return subContentLabel.text ?? "" }
    }

    private let headerLabel = UILabel().then {
        $0.boheomLabel(font: .headerH1Bold)
    }

    private let subContentLabel = UILabel().then {
        $0.boheomLabel(font: .bodyB1Light, textColor: .gray600)
    }

    init(headerText: String?, subContentText: String?) {
        super.init(frame: .zero)
        headerLabel.text = headerText
        subContentLabel.text = subContentText
        isUserInteractionEnabled = false
        addView()
        layout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func addView() {
        addSubviews(headerLabel, subContentLabel)
    }

    private func layout() {
        headerLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
        }
        subContentLabel.snp.makeConstraints {
            $0.top.equalTo(headerLabel.snp.bottom).offset(5)
            $0.leading.trailing.equalTo(headerLabel)
        }
        self.snp.makeConstraints {
            $0.bottom.equalTo(subContentLabel)
        }
    }
}
