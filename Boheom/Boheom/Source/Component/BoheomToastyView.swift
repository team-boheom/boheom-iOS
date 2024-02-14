import UIKit
import Toasty

enum BoheomToastType {
    case succees, error

    var iconImage: UIImage {
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

class BoheomToastyView: ToastyView {
    init(type: BoheomToastType) {
        super.init(
            backgroundColor: type.backgroundColor,
            iconImage: type.iconImage
        )
        contentLabel.font = .bodyB2Bold
        contentLabel.textColor = .white
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

