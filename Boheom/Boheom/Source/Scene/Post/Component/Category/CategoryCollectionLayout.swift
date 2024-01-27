import UIKit

class CategoryCollectionLayout: UICollectionViewFlowLayout {

    override func prepare() {
        super.prepare()
        minimumLineSpacing = 6
        minimumInteritemSpacing = 6
        headerReferenceSize = .init(width: 0, height: 5)
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let atts = super.layoutAttributesForElements(in: rect) else { return [] }
        for (idx, val) in atts.enumerated() {
            if val.frame.origin.x == 0 { continue }
            guard idx - 1 >= 0 else { return [] }
            val.frame.origin.x = atts[idx - 1].frame.maxX + minimumLineSpacing
        }
        return atts
    }
}
