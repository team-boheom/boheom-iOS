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
        case .postDetailIsRequired(let postID):
            return navigateToPostDetailScreen(postID: postID)
        case .postWriteIsRequired:
            return navigateToPostWriteScreen()
        case .navigateBackRequired:
            return navigateToBack()
        case .applyerListIsRequired(let postID):
            return presentToApplyerListScreen(postID: postID)
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

    private func navigateToPostDetailScreen(postID: String) -> FlowContributors {
        let postDetailVC = container.resolve(PostDetailViewController.self)!
        postDetailVC.postID = postID

        self.rootPresentable.pushViewController(postDetailVC, animated: true)
        return .one(flowContributor: .contribute(
            withNextPresentable: postDetailVC,
            withNextStepper: postDetailVC.viewModel
        ))
    }

    private func navigateToPostWriteScreen() -> FlowContributors {
        let postWritelVC = container.resolve(PostWriteViewController.self)!

        self.rootPresentable.pushViewController(postWritelVC, animated: true)
        return .one(flowContributor: .contribute(
            withNextPresentable: postWritelVC,
            withNextStepper: postWritelVC.viewModel
        ))
    }

    private func presentToApplyerListScreen(postID: String) -> FlowContributors {
        let applyerListVC = container.resolve(ApplyerListViewController.self)!
        applyerListVC.postID = postID

        self.rootPresentable.present(applyerListVC, animated: true)
        return .one(flowContributor: .contribute(
            withNextPresentable: applyerListVC,
            withNextStepper: applyerListVC.viewModel
        ))
    }

    private func navigateToBack() -> FlowContributors {
        self.rootPresentable.popViewController(animated: true)
        return .none
    }
}
