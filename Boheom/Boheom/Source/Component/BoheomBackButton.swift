import UIKit
import SnapKit
import Then

public class BoheomBackButton: UIButton {

    private var target: UINavigationController?

    init(_ target: UINavigationController?) {
        super.init(frame: .init(x: 0, y: 0, width: 30, height: 30))
        self.target = target
        setImage(.backArrowRight, for: .normal)
        layer.cornerRadius = 15
        backgroundColor = .white
        tintColor = .gray700
        setShadow()
        layout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        target?.popViewController(animated: true)
    }

    public override var isHighlighted: Bool {
        didSet { self.layer.opacity = isHighlighted ? 0.5 : 1 }
    }

    private func layout() {
        self.snp.makeConstraints {
            $0.width.height.equalTo(30)
        }
    }
}
