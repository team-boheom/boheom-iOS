import RxFlow

public enum BoheomStep: Step {
    
    // onBoarding
    case onBoardingIsRequired

    // login
    case loginIsRequired

    // signup
    case signupIsRequired
    case signupID
    case signupPassword
    case signupComplete

    // home
    case homeIsRequired

    // profile
    case profileIsRequired

    // post
    case postDetailIsRequired(postID: String)
    case postWriteIsRequired
    case postEditIsRequired(postID: String, originData: PostDetailEntity?)
    case applyerListIsRequired(postID: String)

    // navigate
    case navigateBackRequired

    // launchScreen
    case launchScreenIsRequired

    // toast
    case presentToastRequired
}
