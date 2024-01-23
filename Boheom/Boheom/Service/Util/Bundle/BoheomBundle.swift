import Foundation

public enum bundleType {
    case baseURL

    var bundleKey: String {
        switch self {
        case .baseURL:
            return "BaseURL"
        }
    }
}

public class BoheomBundle {
    static let shared = BoheomBundle()
    private init() {}

    func getValue(type: bundleType) -> String {
        guard let bundleValue = (Bundle.main.object(forInfoDictionaryKey: type.bundleKey) as? String)?.dropLast() else {
            print("‼️ Info.pilst is'n contain \"\(type.bundleKey)\"")
            return ""
        }
        return String(bundleValue)
    }
}
