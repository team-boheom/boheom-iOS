import UIKit
import RxFlow

class SignupFlow: Flow {

    var root: Presentable {
        return rootPresentable
    }

    private let rootPresentable: SignupNicknameViewController
    private let container = AppDelegate.container

    init() {
        self.rootPresentable = container.resolve(SignupNicknameViewController.self)!
    }

    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? BoheomStep else { return .none }
        switch step {
        case .signupIsRequired:
            return navigateToSignupNick()
        case .signupID:
            return navigateToSignupID()
        case .signupPassword:
            return navigateToSignupPassword()
        case .signupComplete:
            return navigateToSignupComplete()
        case .loginIsRequired:
            return navigateToLogin()
        case .navigateBackRequired:
            return navigateToBack()
        default:
            return .none
        }
    }

    private func navigateToSignupNick() -> FlowContributors {

        return .one(flowContributor: .contribute(
            withNextPresentable: rootPresentable,
            withNextStepper: rootPresentable.viewModel
        ))
    }

    private func navigateToSignupID() -> FlowContributors {
        let targetView = container.resolve(SignupIDViewController.self)!

        rootPresentable.navigationController?.pushViewController(targetView, animated: true)
        return .one(flowContributor: .contribute(
            withNextPresentable: targetView,
            withNextStepper: targetView.viewModel
        ))
    }

    private func navigateToSignupPassword() -> FlowContributors {
        let targetView = container.resolve(SignupPasswordViewController.self)!

        rootPresentable.navigationController?.pushViewController(targetView, animated: true)
        return .one(flowContributor: .contribute(
            withNextPresentable: targetView,
            withNextStepper: targetView.viewModel
        ))
    }

    private func navigateToSignupComplete() -> FlowContributors {
        let targetView = container.resolve(SignupCompleteViewController.self)!

        rootPresentable.navigationController?.pushViewController(targetView, animated: true)
        return .one(flowContributor: .contribute(
            withNextPresentable: targetView,
            withNextStepper: targetView.viewModel
        ))
    }

    private func navigateToLogin() -> FlowContributors {
        return .end(forwardToParentFlowWithStep: BoheomStep.loginIsRequired)
    }

    private func navigateToBack() -> FlowContributors {
        rootPresentable.navigationController?.popViewController(animated: true)
        return .none
    }

}
