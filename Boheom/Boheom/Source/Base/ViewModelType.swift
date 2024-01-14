import UIKit
import RxSwift

public protocol ViewModelType {

    var disposeBag: DisposeBag { get set }

    associatedtype Input
    associatedtype Output

    func transform(input: Input) -> Output
}
