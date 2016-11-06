import UIKit
import CoreLocation

class ViewController: UIViewController {

    fileprivate let locationManager = CLLocationManager()

    fileprivate lazy var pointerView = TriangleView(color: .blue)
    fileprivate lazy var northPointerView = TriangleView(color: .red)

    fileprivate var doit = true

    var destination: CLLocation = CLLocation(latitude: 50.720893, longitude: -1.879134)
    var currentLocation: CLLocation? {
        didSet { updatePointer() }
    }

    var northHeading: CLLocationDirection? {
        didSet { updatePointer() }
    }

    override func loadView() {
        locationManager.delegate = self

        view = UIView()
        view.backgroundColor = .white
        view.addSubview(northPointerView)
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
            northPointerView.frame = CGRect(x: x, y: y, width: width, height: height)
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

    func updatePointer() {
        if let currentLocation = self.currentLocation, let northBearing = self.northHeading {
            let currentBearing = bearing(fromLocation: currentLocation, toLocation: destination)
            let desiredBearing = currentBearing - northBearing
            pointerView.transform = CGAffineTransform(rotationAngle: CGFloat(desiredBearing.toRadians()))
        }
    }
}

extension ViewController: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        northPointerView.transform = CGAffineTransform(rotationAngle: CGFloat(-newHeading.magneticHeading).toRadians())
        northHeading = newHeading.magneticHeading
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocation = locations.last
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
        }
    }
}
