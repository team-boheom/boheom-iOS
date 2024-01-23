import UIKit
import SnapKit
import Then

class HomeFloatingButton: UIButton {

    public var isAnimaticHidden: Bool = false {
        didSet { animaticHidden(isAnimaticHidden) }
    }

    init() {
        super.init(frame: .zero)
        backgroundColor = .green400
        setImage(.plus, for: .normal)
        layer.cornerRadius = 10
        tintColor = .white
        setShadow()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override var isHighlighted: Bool {
        didSet { highlightAnimation(isHighlighted) }
    }
}

extension HomeFloatingButton {
    private func highlightAnimation(_ status: Bool) {
        UIView.animate(withDuration: 0.1, delay: 0) {
            self.transform = status ? .init(scaleX: 0.98, y: 0.98) : .identity
            self.layer.opacity = status ? 0.7 : 1
        }
    }

    private func animaticHidden(_ status: Bool) {
        UIView.animate(withDuration: 0.2) {
            self.layer.opacity = status ? 0 : 1
        }
    }
}
