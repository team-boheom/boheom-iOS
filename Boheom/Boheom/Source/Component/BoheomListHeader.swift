import UIKit
import SnapKit
import Then

public class BoheomListHeader: UIView {

    private let listHeaderStack = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 5
    }

    private let titleView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 20
        $0.setShadow()
    }
    private let titleLabel = UILabel().then {
        $0.boheomLabel(text: "제목", font: .bodyB3Bold)
    }

    let navigateButton = UIButton(type: .system).then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 20
        $0.setImage(.leftArrow, for: .normal)
        $0.tintColor = .gray800
        $0.setShadow()
    }

    init(title: String?, isShowNavigate: Bool = true) {
        super.init(frame: .zero)
        titleLabel.text = title
        navigateButton.isHidden = !isShowNavigate
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func layoutSubviews() {
        addView()
        layout()
    }

    private func addView() {
        titleView.addSubview(titleLabel)
        [titleView, navigateButton].forEach(listHeaderStack.addArrangedSubview(_:))
        addSubview(listHeaderStack)
    }

    private func layout() {
        navigateButton.snp.makeConstraints {
            $0.width.height.equalTo(40)
        }
        titleView.snp.makeConstraints {
            $0.height.equalTo(40)
        }
        titleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(15)
        }
        listHeaderStack.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(titleView)
        }
        self.snp.makeConstraints {
            $0.bottom.equalTo(listHeaderStack)
        }
    }
}
