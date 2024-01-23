import UIKit
import SnapKit
import Then

class ToastViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .clear
        view.isUserInteractionEnabled = false
    }
}

extension ToastViewController {
    public func presentToast(with content: String) {

        HapticManager.shared.hapticNotification(type: .error)
        let toastView = ToastView(message: content)
        view.addSubview(toastView)

        toastView.snp.makeConstraints {
            $0.height.equalTo(view.safeAreaInsets.top + 50)
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
