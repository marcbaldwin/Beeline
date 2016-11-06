import UIKit
import CoreLocation

class ViewController: UIViewController {

    fileprivate let locationManager = CLLocationManager()

    fileprivate lazy var pointerView = TriangleView(color: .blue)

    fileprivate var doit = true

    override func loadView() {
        locationManager.delegate = self

        view = UIView()
        view.backgroundColor = .white
        view.addSubview(pointerView)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if doit {
            let width = min(view.bounds.width, view.bounds.height) * 0.25
            let height = (width / 2) * sqrt(3)
            let x = view.bounds.midX - (width / 2)
            let y = view.bounds.midY - (height / 2)
            pointerView.frame = CGRect(x: x, y: y, width: width, height: height)
            doit = false
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        locationManager.startUpdatingHeading()

        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        locationManager.stopUpdatingLocation()
    }
}

extension ViewController: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        pointerView.transform = CGAffineTransform(rotationAngle: CGFloat(-newHeading.magneticHeading).toRadians())
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
        }
    }
}
