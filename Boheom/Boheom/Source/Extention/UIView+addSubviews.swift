import UIKit

extension UIView {
    func addSubviews(_ views: UIView...) {
        views.forEach(self.addSubview(_:))
    }

    func addSubviews(_ views: [UIView]) {
        views.forEach(self.addSubview(_:))
    }
}
