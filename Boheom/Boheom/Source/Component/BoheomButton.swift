import UIKit

public enum BoheomButtonType {
    case fill
    case outline
    case text
}

public class BoheomButton: UIButton {

    public var isDisable: Bool = false {
        didSet { isDisable ? disableButton() : activateButton() }
    }

    private var type: BoheomButtonType = .fill
    private var pointColor: UIColor?
    private var textColor: UIColor?

    init(
        text: String?,
        font: UIFont? = .bodyB1Medium,
        textColor: UIColor? = .white,
        pointColor: UIColor? = .green500Main,
        type: BoheomButtonType,
        cornerRadius: CGFloat = 8
    ) {
        super.init(frame: .zero)
        switch type {
        case .fill:
            backgroundColor = pointColor
            setTitleColor(textColor, for: .normal)
        case .outline:
            layer.borderWidth = 1
            layer.borderColor = pointColor?.cgColor
            setTitleColor(pointColor, for: .normal)
            backgroundColor = .white
        case .text:
            backgroundColor = .clear
            setTitleColor(textColor, for: .normal)
        }

        setTitle(text, for: .normal)
        titleLabel?.font = font
        layer.cornerRadius = cornerRadius

        self.type = type
        self.pointColor = pointColor
        self.textColor = textColor
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override var isHighlighted: Bool {
        didSet { layer.opacity = isHighlighted ? 0.7 : 1 }
    }
}

extension BoheomButton {
    private func disableButton() {
        isEnabled = false
        switch type {
        case .fill:
            backgroundColor = .gray300
        case .outline:
            layer.borderColor = UIColor.gray300.cgColor
            setTitleColor(.gray300, for: .normal)
        case .text:
            setTitleColor(.gray300, for: .normal)
        }
        
    }

    private func activateButton() {
        isEnabled = true
        switch type {
        case .fill:
            backgroundColor = pointColor
        case .outline:
            layer.borderColor = pointColor?.cgColor
            setTitleColor(pointColor, for: .normal)
        case .text:
            setTitleColor(textColor, for: .normal)
        }
    }
}
