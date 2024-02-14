import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa
import Toasty

open class BaseVC<T: ViewModelType>: UIViewController {

    var disposeBag = DisposeBag()
    var viewModel: T
    lazy var toastController = ToastyController(target: self)

    public init(viewModel: T) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    open override func viewDidLoad() {
        super.viewDidLoad()
        attribute()
        bind()
    }

    open override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        addView()
        layout()
        view.addSubview(toastController.view)
    }

    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }

    public func attribute() {}
    public func addView() {}
    public func layout() {}
    public func bind() {}
}
