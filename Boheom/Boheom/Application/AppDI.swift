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
    }

    private func registerViewModelDependencies() {
        self.register(LoginViewModel.self) { resolver in
            LoginViewModel(authService: resolver.resolve(AuthService.self)!)
        }
        self.register(SignupViewModel.self) { resolver in
            SignupViewModel(authService: resolver.resolve(AuthService.self)!)
        }
        self.register(OnBoardingViewModel.self) { _ in OnBoardingViewModel() }
        // TODO: service 만들어서 주입해야 함
        self.register(HomeViewModel.self) { _ in HomeViewModel() }
        self.register(ProfileViewModel.self) { _ in ProfileViewModel() }
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
    }
}
