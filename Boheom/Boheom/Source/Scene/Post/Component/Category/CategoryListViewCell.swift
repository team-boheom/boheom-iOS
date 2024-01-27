import UIKit
import SnapKit
import Then

class CategoryListViewCell: UICollectionViewCell {
    
    static let identifier: String = "CategoryListViewCell"

    private let categoryLabel = UILabel().then {
        $0.font = .bodyB2SemiBold
        $0.textColor = .green700
    }

    public func setup(category: String?) {
        categoryLabel.text = category
        layer.cornerRadius = 12
        backgroundColor = .green150
        addSubview(categoryLabel)
        categoryLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}
