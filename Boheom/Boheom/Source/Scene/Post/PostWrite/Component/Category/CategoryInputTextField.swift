import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

class CategoryInputTextField: BoheomTextField {

    private let disposeBag: DisposeBag = .init()

    public let categoryList = BehaviorRelay<[String]>(value: [])

    private let appendCategoryButton = UIButton(type: .system).then {
        $0.setImage(.circlePlus, for: .normal)
        $0.tintColor = .green600
    }

    private let categoryLayout = CategoryCollectionLayout()
    private lazy var categoryListView = UICollectionView(frame: .zero, collectionViewLayout: categoryLayout).then {
        $0.backgroundColor = .clear
        $0.isScrollEnabled = false
        $0.register(CategoryListViewCell.self, forCellWithReuseIdentifier: CategoryListViewCell.identifier)
    }

    init() {
        super.init(title: "태그", placeholder: "태그를 입력하세요. (4개 이하)")
        let padding = UIView(frame: .init(x: 0, y: 0, width: 34, height: 0))
        textField.rightView = padding
        textFieldStackView.addArrangedSubview(categoryListView)
        bind()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        addView()
        layout()
    }

    private func bind() {
        categoryListView.rx.setDelegate(self)
            .disposed(by: disposeBag)

        categoryList
            .bind(to: categoryListView.rx.items(
                cellIdentifier: CategoryListViewCell.identifier,
                cellType: CategoryListViewCell.self
            )) { [weak self] index, element, cell in
                guard let self else { return }
                cell.setup(category: "#\(element)")
                self.layout()
            }
            .disposed(by: disposeBag)

        appendCategoryButton.rx.tap.compactMap { self.textField.text }
            .filter { !$0.isEmpty }
            .bind(with: self, onNext: { owner, str in
                var appendValue = owner.categoryList.value
                appendValue.append(str)
                owner.categoryList.accept(appendValue)
                owner.textField.text = ""
            })
            .disposed(by: disposeBag)
    }

    override func addView() {
        super.addView()
        textField.addSubview(appendCategoryButton)
    }

    override func layout() {
        super.layout()
        appendCategoryButton.snp.makeConstraints {
            $0.width.height.equalTo(24)
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(8)
        }
        categoryListView.snp.updateConstraints {
            $0.width.equalToSuperview()
            $0.height.equalTo(categoryListView.contentSize.height + 1)
        }
    }
}

extension CategoryInputTextField: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(
            width: ("#" + categoryList.value[indexPath.item] as NSString).size(withAttributes: [.font: UIFont.bodyB2Regular!]).width + 20,
            height: 36
        )
    }
}
