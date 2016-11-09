import UIKit
import CoreLocation
import RxSwift

class ViewController: UIViewController {

    fileprivate lazy var pointerView = TriangleView(color: .blue)
    fileprivate lazy var northPointerView = TriangleView(color: .red)
    fileprivate lazy var circleView: UIView = {
        let view = UIView()
        view.layer.borderWidth = 10
        view.layer.cornerRadius = 100
        view.layer.borderColor = UIColor.blue.cgColor
        return view
    }()

    fileprivate var layoutSubviews = true

    fileprivate let navigator = Navigator()
    fileprivate let disposeBag = DisposeBag()

    override func loadView() {
        view = UIView()
        view.backgroundColor = .white
        view.addSubview(circleView)
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
            let radius = CGFloat(100)
            let width = CGFloat(60)
            let height = (width / 2) * sqrt(3)

            circleView.frame = CGRect(x: view.bounds.midX - radius, y: view.bounds.midY - radius, width: radius*2, height: radius*2)

            northPointerView.frame = CGRect(x: 0, y: 0, width: width, height: height)
            northPointerView.center = view.center

            pointerView.bounds = CGRect(x: 0, y: 0, width: width, height: height)
            pointerView.center = view.center
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
        northPointerView.transform = translate(bearing: bearing)
    }

    func updatePointer(bearing: Double) {
        pointerView.transform = translate(bearing: bearing)
    }

    func translate(bearing: Double) -> CGAffineTransform {
        return CGAffineTransform.identity.rotated(by: CGFloat(bearing).toRadians())
    }
}
