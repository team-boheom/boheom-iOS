import UIKit
import Then

class LogoutAlert: UIAlertController {

    private let cancelAction = UIAlertAction(title: "취소", style: .cancel)

    init(logoutAction: @escaping () -> Void) {
        super.init(nibName: nil, bundle: nil)
        title = "알림"
        message = "정말 로그아웃 하실건가요?"
        let logoutAction = UIAlertAction(title: "로그아웃", style: .destructive) { _ in
            logoutAction()
        }
        [
            cancelAction,
            logoutAction
        ].forEach(addAction(_:))
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
