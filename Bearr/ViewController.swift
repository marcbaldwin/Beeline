import UIKit
import CoreLocation
import RxSwift

class ViewController: UIViewController {

    fileprivate let navigator = Navigator()
    fileprivate let disposeBag = DisposeBag()

    lazy var navigationView = NavigationView(frame: CGRect.zero)

    override func loadView() {
        view = navigationView

        navigator.magneticHeading.asObservable()
            .subscribe(onNext: navigationView.updateNorthPointer(bearing:))
            .addDisposableTo(disposeBag)

        navigator.destinationHeading
            .subscribe(onNext: navigationView.updatePointer(bearing:))
            .addDisposableTo(disposeBag)

        navigator.currentLocation
            .filter { $0 != nil }
            .map { $0! }
            .subscribe(onNext: navigationView.updateLocation)
            .addDisposableTo(disposeBag)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigator.start()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigator.stop()
    }
}
