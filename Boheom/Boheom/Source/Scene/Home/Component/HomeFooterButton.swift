import UIKit
import SnapKit
import Then

class HomeFooterButton: UIButton {

    private let firstHeaderLabel = UILabel().then {
        $0.boheomLabel(text: "찾는 보드게임이 없으신가요? 💭", font: .bodyB2Bold)
    }

    private let secondHeaderLabel = UILabel().then {
        let text = "원하는 보드게임을 만들어보세요!"
        let arrText = NSMutableAttributedString(string: text)
        arrText.addAttribute(.foregroundColor, value: UIColor.green500Main, range: (text as NSString).range(of: "보드게임"))
        $0.attributedText = arrText
        $0.font = .bodyB1Bold
    }

    private let arrowImageView = UIImageView(image: .smallArrowLeft).then {
        $0.tintColor = .gray500
    }

    override var isHighlighted: Bool {
        didSet { self.layer.opacity = isHighlighted ? 0.5 : 1 }
    }

    init() {
        super.init(frame: .zero)
        backgroundColor = .white
        layer.cornerRadius = 8
        setShadow()
        addview()
        layout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func addview() {
        addSubviews(firstHeaderLabel, secondHeaderLabel, arrowImageView)
    }

    private func layout() {
        firstHeaderLabel.snp.makeConstraints {
            $0.leading.trailing.top.equalToSuperview().inset(12)
        }
        secondHeaderLabel.snp.makeConstraints {
            $0.top.equalTo(firstHeaderLabel.snp.bottom).offset(3)
            $0.leading.trailing.equalToSuperview().inset(12)
        }
        arrowImageView.snp.makeConstraints {
            $0.width.height.equalTo(16)
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(6)
        }
        self.snp.makeConstraints {
            $0.bottom.equalTo(secondHeaderLabel).offset(12)
        }
    }
}
