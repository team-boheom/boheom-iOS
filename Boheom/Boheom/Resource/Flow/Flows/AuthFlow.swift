import UIKit
import RxFlow

class AuthFlow: Flow {

    var root: Presentable {
        return rootPresentable
    }

    private let rootPresentable = UINavigationController()

    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? BoheomStep else { return .none }
        switch step {
        case .onBoardingIsRequired:
            return navigateToOnBoardingScreen()
        case .loginIsRequired:
            return .none
        default:
            return .none
        }
    }
    
    private func navigateToOnBoardingScreen() -> FlowContributors {
        let onBoardingVC = OnBoardingViewController()

        self.rootPresentable.pushViewController(onBoardingVC, animated: false)
        return .none
    }
}
