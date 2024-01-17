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

    private let container = AppDelegate.container

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
        let signupFlow = SignupFlow()

        Flows.use(signupFlow, when: .created) { flowRoot in
            self.rootPresentable.pushViewController(flowRoot, animated: true)
        }

        return .one(flowContributor: .contribute(
            withNextPresentable: signupFlow,
            withNextStepper: OneStepper(withSingleStep: BoheomStep.signupIsRequired)
        ))
    }

    private func navigateToLoginScreen() -> FlowContributors {
        let loginVC = container.resolve(LoginViewController.self)!

        self.rootPresentable.pushViewController(loginVC, animated: true)
        return .one(flowContributor: .contribute(
            withNextPresentable: loginVC,
            withNextStepper: loginVC.viewModel
        ))
    }

}
