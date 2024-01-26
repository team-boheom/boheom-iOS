import UIKit
import RxFlow

class AppFlow: Flow {
    var root: Presentable {
        return rootPresentable
    }

    private let rootPresentable: UIWindow

    init(rootPresentable: UIWindow) {
        self.rootPresentable = rootPresentable
    }

    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? BoheomStep else { return .none }
        switch step {
        case .onBoardingIsRequired:
            return navigateToOnBoardingScreen()
        case .homeIsRequired:
            return navigateToHomeScreen()
        case .launchScreenIsRequired:
            return presentTolaunchScreen()
        default:
            return .none
        }
    }

    private func presentTolaunchScreen() -> FlowContributors {
        let launchVC = UIViewController()
        launchVC.view.backgroundColor = .gray50

        self.rootPresentable.rootViewController = launchVC
        self.rootPresentable.makeKeyAndVisible()
        return .none
    }

    private func navigateToOnBoardingScreen() -> FlowContributors {
        let authFlow = AuthFlow()
        Flows.use(authFlow, when: .created) { root in
            self.rootPresentable.rootViewController = root
            self.rootPresentable.makeKeyAndVisible()
        }
        return .one(flowContributor: .contribute(
            withNextPresentable: authFlow,
            withNextStepper: OneStepper(withSingleStep: BoheomStep.onBoardingIsRequired)
        ))
    }

    private func navigateToHomeScreen() -> FlowContributors {
        let homeFlow = HomeFlow()
        Flows.use(homeFlow, when: .created) { root in
            self.rootPresentable.rootViewController = root
            self.rootPresentable.makeKeyAndVisible()
        }
        return .one(flowContributor: .contribute(
            withNextPresentable: homeFlow,
            withNextStepper: OneStepper(withSingleStep: BoheomStep.homeIsRequired)
        ))
    }
}
