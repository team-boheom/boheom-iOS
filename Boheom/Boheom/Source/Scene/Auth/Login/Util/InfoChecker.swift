import Foundation

enum CheckerType {
    case password, id, nickname

    var regex: String {
        switch self {
        case .password:
            return "(?=.*[a-z])(?=.*[0-9])(?=.*[!#$%&'()*+,./:;<=>?@＼^_`{|}~])[a-zA-Z0-9!#$%&'()*+,./:;<=>?@＼^_`{|}~]{8,30}$"
        case .id:
            return "^([a-zA-Z0-9]){1,10}$"
        case .nickname:
            return "^([가-힣ㄱ-ㅎㅏ-ㅣa-zA-Z0-9]){1,12}$"
        }
    }
}

class InfoChecker {
    func checkValid(of type: CheckerType, _ target: String) -> Bool {
        return target.range(of: type.regex, options: .regularExpression) != nil
    }
}
