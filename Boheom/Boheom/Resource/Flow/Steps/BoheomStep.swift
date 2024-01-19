import RxFlow

public enum BoheomStep: Step {
    
    //onBoarding
    case onBoardingIsRequired

    // login
    case loginIsRequired

    // signup
    case signupIsRequired
    case signupID
    case signupPassword
    case signupComplete

    //home
    case homeIsRequired

    //profile
    case profileIsRequired

    //navigate
    case navigateBackRequired
}
