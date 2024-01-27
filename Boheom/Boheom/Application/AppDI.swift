import Foundation
import Swinject

public extension Container {

    func registerAppDependencies() {
        registerServiceDependencies()
        registerViewModelDependencies()
        registerViewControllerDependencies()
    }

    private func registerServiceDependencies() {
        self.register(AuthService.self) { _ in AuthService() }
        self.register(UserService.self) { _ in UserService() }
        self.register(FeedService.self) { _ in FeedService() }
    }

    private func registerViewModelDependencies() {
        self.register(LoginViewModel.self) { resolver in
            LoginViewModel(authService: resolver.resolve(AuthService.self)!)
        }
        self.register(SignupViewModel.self) { resolver in
            SignupViewModel(authService: resolver.resolve(AuthService.self)!)
        }
        self.register(OnBoardingViewModel.self) { _ in OnBoardingViewModel() }
        self.register(HomeViewModel.self) { resolver in
            HomeViewModel(
                userService: resolver.resolve(UserService.self)!,
                feedService: resolver.resolve(FeedService.self)!
            )
        }
        self.register(ProfileViewModel.self) { resolver in
            ProfileViewModel(
                userService: resolver.resolve(UserService.self)!,
                feedService: resolver.resolve(FeedService.self)!
            )
        }
        self.register(PostDetailViewModel.self) { resolver in
            PostDetailViewModel(feedService: resolver.resolve(FeedService.self)!)
        }
        self.register(PostWriteViewModel.self) { resolver in
            PostWriteViewModel(feedService: resolver.resolve(FeedService.self)!)
        }
        self.register(PostEditViewModel.self) { resolver in
            PostEditViewModel(feedService: resolver.resolve(FeedService.self)!)
        }
        self.register(ApplyerListViewModel.self) { resolver in
            ApplyerListViewModel(feedService: resolver.resolve(FeedService.self)!)
        }
    }

    private func registerViewControllerDependencies() {
        self.register(OnBoardingViewController.self) { resolver in
            OnBoardingViewController(viewModel: resolver.resolve(OnBoardingViewModel.self)!)
        }
        self.register(LoginViewController.self) { resolver in
            LoginViewController(viewModel: resolver.resolve(LoginViewModel.self)!)
        }
        self.register(SignupNicknameViewController.self) { resolver in
            SignupNicknameViewController(viewModel: resolver.resolve(SignupViewModel.self)!)
        }
        self.register(SignupIDViewController.self) { resolver in
            SignupIDViewController(viewModel: resolver.resolve(SignupViewModel.self)!)
        }
        self.register(SignupPasswordViewController.self) { resolver in
            SignupPasswordViewController(viewModel: resolver.resolve(SignupViewModel.self)!)
        }
        self.register(SignupCompleteViewController.self) { resolver in
            SignupCompleteViewController(viewModel: resolver.resolve(SignupViewModel.self)!)
        }
        self.register(HomeViewController.self) { resolver in
            HomeViewController(viewModel: resolver.resolve(HomeViewModel.self)!)
        }
        self.register(ProfileViewController.self) { resolver in
            ProfileViewController(viewModel: resolver.resolve(ProfileViewModel.self)!)
        }
        self.register(PostDetailViewController.self) { resolver in
            PostDetailViewController(viewModel: resolver.resolve(PostDetailViewModel.self)!)
        }
        self.register(PostWriteViewController.self) { resolver in
            PostWriteViewController(viewModel: resolver.resolve(PostWriteViewModel.self)!)
        }
        self.register(PostEditViewController.self) { resolver in
            PostEditViewController(viewModel: resolver.resolve(PostEditViewModel.self)!)
        }
        self.register(ApplyerListViewController.self) { resolver in
            ApplyerListViewController(viewModel: resolver.resolve(ApplyerListViewModel.self)!)
        }
    }
}
