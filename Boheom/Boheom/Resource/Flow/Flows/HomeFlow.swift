import UIKit
import RxFlow

class HomeFlow: Flow {

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
        case .homeIsRequired:
            return navigateToHomeScreen()
        case .profileIsRequired:
            return navigateToProfileScreen()
        case .postDetailIsRequired:
            return navigateToPostDetailScreen()
        default:
            return .none
        }
    }
    
    private func navigateToHomeScreen() -> FlowContributors {
        let homeVC = container.resolve(HomeViewController.self)!

        self.rootPresentable.pushViewController(homeVC, animated: false)
        return .one(flowContributor: .contribute(
            withNextPresentable: homeVC,
            withNextStepper: homeVC.viewModel
        ))
    }

    private func navigateToProfileScreen() -> FlowContributors {
        let profileVC = container.resolve(ProfileViewController.self)!

        self.rootPresentable.pushViewController(profileVC, animated: true)
        return .one(flowContributor: .contribute(
            withNextPresentable: profileVC,
            withNextStepper: profileVC.viewModel
        ))
    }

    private func navigateToPostDetailScreen() -> FlowContributors {
        let postDetailVC = container.resolve(PostDetailViewController.self)!

        self.rootPresentable.pushViewController(postDetailVC, animated: true)
        return .one(flowContributor: .contribute(
            withNextPresentable: postDetailVC,
            withNextStepper: postDetailVC.viewModel
        ))
    }
}
