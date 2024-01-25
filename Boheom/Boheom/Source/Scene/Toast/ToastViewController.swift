import UIKit
import SnapKit
import Then

enum toastType {
    case succees, error

    var iconImege: UIImage {
        switch self {
        case .succees: return .checkCircleFill
        case .error: return .xCircleFill
        }
    }

    var backgroundColor: UIColor {
        switch self {
        case .succees: return .extraBlue
        case .error: return .extraRed
        }
    }

    var feedBackType: UINotificationFeedbackGenerator.FeedbackType {
        switch self {
        case .succees: return .success
        case .error: return .error
        }
    }
}

class ToastViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .clear
        view.isUserInteractionEnabled = false
    }
}

extension ToastViewController {
    public func presentToast(with content: String, type: toastType) {

        HapticManager.shared.hapticNotification(type: type.feedBackType)
        let toastView = ToastView(message: content, type: type)
        view.addSubview(toastView)

        toastView.snp.makeConstraints {
            $0.height.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalTo(view.snp.top)
        }

        UIView.animateKeyframes(
            withDuration: 4,
            delay: 0,
            animations: {
                UIView.addKeyframe(
                    withRelativeStartTime: 0,
                    relativeDuration: 0.005 / 4,
                    animations: { toastView.transform = .init(translationX: 0, y: self.view.safeAreaInsets.top + 50) }
                )

                UIView.addKeyframe(
                    withRelativeStartTime: 3 / 4,
                    relativeDuration: 0.1 / 4,
                    animations: { toastView.transform = .identity }
                )
            },
            completion: { _ in toastView.removeFromSuperview()  }
        )
    }
}
