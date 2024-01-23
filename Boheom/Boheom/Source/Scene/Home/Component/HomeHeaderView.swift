import UIKit
import SnapKit
import Then

class HomeHeaderView: UIView {

    public var userName: String {
        set { helloLabel.text = "안녕하세요, \(newValue)님! 👋" }
        get { helloLabel.text ?? ""}
    }

    private let helloLabel = UILabel().then {
        $0.boheomLabel(text: "안녕하세요, 님! 👋", font: .bodyB1Light)
    }

    private let headerLabel = UILabel().then {
        $0.boheomLabel(font: .headerH2Bold)
        $0.numberOfLines = 0
        let attrString = NSMutableAttributedString(string: "보드게임\n모험을 시작해볼까요?")
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.2
        attrString.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attrString.length))
        $0.attributedText = attrString
    }

    override func layoutSubviews() {
        addView()
        layout()
    }

    private func addView() {
        addSubviews(helloLabel, headerLabel)
    }

    private func layout() {
        helloLabel.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
        }
        headerLabel.snp.makeConstraints {
            $0.top.equalTo(helloLabel.snp.bottom).offset(2)
            $0.leading.trailing.equalToSuperview()
        }
        self.snp.makeConstraints {
            $0.bottom.equalTo(headerLabel)
        }
    }
}
