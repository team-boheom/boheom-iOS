import UIKit

extension UIView {
    func setShadow() {
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowRadius = 15
        self.layer.shadowOpacity = 0.05
        self.layer.shadowOffset = .init(width: 0, height: 4)
    }
}
