import UIKit
import CoreLocation
import RxSwift
import RxCocoa

class ViewController: UIViewController {

    fileprivate let navigator = Navigator()
    fileprivate let disposeBag = DisposeBag()

    lazy var navigationView = NavigationView(frame: CGRect.zero)

    override func loadView() {
        view = navigationView

        navigator.magneticHeading.asObservable()
            .subscribe(onNext: navigationView.set(northHeading:))
            .addDisposableTo(disposeBag)

        navigator.destinationHeading
            .subscribe(onNext: navigationView.set(destinationHeading:))
            .addDisposableTo(disposeBag)

        navigator.currentLocation
            .subscribe(onNext: navigationView.set(location:))
            .addDisposableTo(disposeBag)

        navigator.speed.map { "\($0/1000) km/h" }
            .bindTo(navigationView.speedLabel.rx.text)
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
