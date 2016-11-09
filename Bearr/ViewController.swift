import UIKit
import CoreLocation
import RxSwift

class ViewController: UIViewController {

    fileprivate lazy var pointerView = TriangleView(color: .blue)
    fileprivate lazy var northPointerView = TriangleView(color: .red)

    fileprivate var layoutSubviews = true

    fileprivate let navigator = Navigator()
    fileprivate let disposeBag = DisposeBag()

    override func loadView() {
        view = UIView()
        view.backgroundColor = .white
        view.addSubview(northPointerView)
        view.addSubview(pointerView)

        navigator.magneticHeading.asObservable()
            .subscribe(onNext: updateNorthPointer(bearing:))
            .addDisposableTo(disposeBag)

        navigator.destinationHeading
            .subscribe(onNext: updatePointer(bearing:))
            .addDisposableTo(disposeBag)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if layoutSubviews {
            let width = min(view.bounds.width, view.bounds.height) * 0.25
            let height = (width / 2) * sqrt(3)
            let x = view.bounds.midX - (width / 2)
            let y = view.bounds.midY - (height / 2)
            pointerView.frame = CGRect(x: x, y: y, width: width, height: height)
            northPointerView.frame = CGRect(x: x, y: y, width: width, height: height)
            layoutSubviews = false
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigator.start()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigator.stop()
    }

    func updateNorthPointer(bearing: Double) {
        northPointerView.transform = CGAffineTransform(rotationAngle: CGFloat(bearing.toRadians()))
    }

    func updatePointer(bearing: Double) {
        pointerView.transform = CGAffineTransform(rotationAngle: CGFloat(bearing.toRadians()))
    }
}
