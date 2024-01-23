import UIKit
import SnapKit
import Then

public class BoheomTextView: UIView {
    private let titleLabel = UILabel().then {
        $0.boheomLabel(font: .bodyB2Regular, textColor: .gray500)
    }

    private let placeHolderLabel = UILabel().then {
        $0.boheomLabel(font: .bodyB1Regular, textColor: .gray500)
        $0.isUserInteractionEnabled = false
        $0.numberOfLines = 0
    }

    let inputTextView = UITextView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 8
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.gray100.cgColor
        $0.contentInset = .init(top: 12, left: 8, bottom: 12, right: 8)
        $0.font = .bodyB1Regular
    }

    init(title: String?, placeholder: String?) {
        super.init(frame: .zero)
        titleLabel.text = title
        placeHolderLabel.text = placeholder
        inputTextView.showsVerticalScrollIndicator = false
        inputTextView.delegate = self
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func layoutSubviews() {
        addview()
        layout()
    }

    private func addview() {
        inputTextView.addSubview(placeHolderLabel)
        addSubviews(titleLabel, inputTextView)
    }

    private func layout() {
        titleLabel.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
        }
        inputTextView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(4)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(252)
        }
        placeHolderLabel.snp.makeConstraints {
            $0.top.bottom.trailing.equalToSuperview().inset(9)
            $0.leading.equalToSuperview().inset(4)
        }
        self.snp.makeConstraints {
            $0.bottom.equalTo(inputTextView)
        }
    }
}

extension BoheomTextView: UITextViewDelegate {
    public func textViewDidChange(_ textView: UITextView) {
        placeHolderLabel.isHidden = !textView.text.isEmpty
    }
}
