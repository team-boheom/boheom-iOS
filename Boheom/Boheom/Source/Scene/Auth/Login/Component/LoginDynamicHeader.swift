import UIKit
import SnapKit
import Then

class LoginDynamicHeader: UIView {

    private let firstPartLabel = UILabel().then {
        $0.boheomLabel(text: "다시", font: .headerH1Bold)
        $0.textAlignment = .left
    }

    private let dynamicLabel = UILabel().then {
        $0.boheomLabel(text: "모험🎲", font: .headerH1Bold, textColor: .green500Main)
        $0.textAlignment = .left
    }

    private let secondPartLabel = UILabel().then {
        $0.boheomLabel(text: "을", font: .headerH1Bold)
        $0.textAlignment = .left
    }

    private let underPartLabel = UILabel().then {
        $0.boheomLabel(text: "시작해 볼까요?", font: .headerH1Bold)
        $0.textAlignment = .left
    }

    init() {
        super.init(frame: .zero)
        addSubviews(
            firstPartLabel,
            dynamicLabel,
            secondPartLabel,
            underPartLabel
        )
        layout()
        startAnimation()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func layout() {
        firstPartLabel.snp.makeConstraints {
            $0.leading.top.equalToSuperview()
        }
        dynamicLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalTo(firstPartLabel.snp.trailing).offset(4)
        }
        secondPartLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalTo(dynamicLabel.snp.trailing).offset(4)
        }
        underPartLabel.snp.makeConstraints {
            $0.top.equalTo(firstPartLabel.snp.bottom).offset(5)
            $0.leading.equalToSuperview()
        }
        self.snp.makeConstraints {
            $0.trailing.equalTo(underPartLabel)
            $0.bottom.equalTo(underPartLabel)
        }
    }
}

extension LoginDynamicHeader {
    private func startAnimation() {
        let emojiList = ["🎲", "🎮", "🎯", "🧩", "♟️"]
        var selectIndex = 0
        Timer.scheduledTimer(withTimeInterval: 0.3, repeats: true) { [weak self] timer in
            guard let self else { return }
            selectIndex += 1
            if selectIndex >= emojiList.count { selectIndex = 0 }
            DispatchQueue.main.async { self.dynamicLabel.text = "모험\(emojiList[selectIndex])" }
        }
    }
}
