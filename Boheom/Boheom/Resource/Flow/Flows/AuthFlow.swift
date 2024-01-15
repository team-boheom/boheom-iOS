import UIKit
import RxFlow

class AuthFlow: Flow {

    var root: Presentable {
        return rootPresentable
    }

    private let rootPresentable = {
        let navigationVC = UINavigationController()
        navigationVC.navigationBar.isHidden = true
        return navigationVC
    }()

    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? BoheomStep else { return .none }
        switch step {
        case .onBoardingIsRequired:
            return navigateToOnBoardingScreen()
        case .loginIsRequired:
            return navigateToLoginScreen()
        case .signupIsRequired:
            return navigateToSignupScreen()
        default:
            return .none
        }
    }
    
    private func navigateToOnBoardingScreen() -> FlowContributors {
        let viewModel = OnBoardingViewModel()
        let onBoardingVC = OnBoardingViewController(viewModel: viewModel)

        self.rootPresentable.pushViewController(onBoardingVC, animated: false)
        return .one(flowContributor: .contribute(
            withNextPresentable: onBoardingVC,
            withNextStepper: viewModel
        ))
    }

    private func navigateToSignupScreen() -> FlowContributors {
        let viewModel = SignupViewModel()
        let signupVC = SignupViewController(viewModel: viewModel)

        self.rootPresentable.pushViewController(signupVC, animated: true)
        return .one(flowContributor: .contribute(
            withNextPresentable: signupVC,
            withNextStepper: viewModel
        ))
    }

    private func navigateToLoginScreen() -> FlowContributors {
        let viewModel = LoginViewModel()
        let loginVC = LoginViewController(viewModel: viewModel)

        self.rootPresentable.pushViewController(loginVC, animated: true)
        return .one(flowContributor: .contribute(
            withNextPresentable: loginVC,
            withNextStepper: viewModel
        ))
    }

}
