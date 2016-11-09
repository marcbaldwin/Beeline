import UIKit
import CoreLocation
import RxSwift

class ViewController: UIViewController {

    fileprivate lazy var pointerView = TriangleView(color: .neonBlue)
    fileprivate lazy var northPointerView = TriangleView(color: .white)
    fileprivate lazy var circleView: UIView = {
        let view = UIView()
        view.layer.borderWidth = 10
        view.layer.cornerRadius = 100
        view.layer.borderColor = UIColor.neonBlue.cgColor
        return view
    }()

    fileprivate var layoutSubviews = true

    fileprivate let navigator = Navigator()
    fileprivate let disposeBag = DisposeBag()

    fileprivate var radius: CGFloat = 100
    fileprivate let northPointerSize = CGSize(width: 40, height: 20)

    override func loadView() {
        view = UIView()
        view.backgroundColor = .darkBackground
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
            circleView.frame = CGRect(x: view.bounds.midX - radius, y: view.bounds.midY - radius, width: radius*2, height: radius*2)

            northPointerView.frame = CGRect(x: 0, y: 0, width: northPointerSize.width, height: northPointerSize.height)
            northPointerView.center = view.center

            pointerView.bounds = CGRect(x: 0, y: 0, width: 40, height: 60)
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
        let bearing = CGFloat(bearing - 90).toRadians()
        let radius = self.radius + 10 + (northPointerSize.height / 2)
        let x = view.center.x + radius * cos(bearing)
        let y = view.center.y + radius * sin(bearing)
        northPointerView.center = CGPoint(x: x, y: y)
    }

    func updatePointer(bearing: Double) {
        pointerView.transform = translate(bearing: bearing)
    }

    func translate(bearing: Double) -> CGAffineTransform {
        return CGAffineTransform.identity.rotated(by: CGFloat(bearing).toRadians())
    }
}
