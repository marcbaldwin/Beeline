import CoreLocation
import RxSwift

class Navigator: NSObject {

    fileprivate let locationManager = CLLocationManager()
    fileprivate let destinationBearing = BehaviorSubject<CLLocationDirection>(value: 0)

    let magneticHeading = BehaviorSubject<CLLocationDirection>(value: 0)
    let destinationHeading: Observable<CLLocationDirection>

    fileprivate var destination: CLLocation = CLLocation(latitude: 50.796346, longitude: -1.881024)

    override init() {
        destinationHeading = Observable.combineLatest(magneticHeading, destinationBearing) { $0 + $1 }
    }

    func start() {
        locationManager.delegate = self
        locationManager.startUpdatingHeading()

        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }

    func stop() {
        locationManager.stopUpdatingHeading()
        locationManager.stopUpdatingLocation()
        locationManager.delegate = nil
    }
}

extension Navigator: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        magneticHeading.onNext(-newHeading.magneticHeading)
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let currentLocation = locations.last {
            destinationBearing.onNext(bearing(fromLocation: currentLocation, toLocation: destination))
        }
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
        }
    }
}

func bearing(fromLocation: CLLocation, toLocation: CLLocation) -> CLLocationDirection {

    let fromLat = fromLocation.coordinate.latitude.toRadians()
    let fromLon = fromLocation.coordinate.longitude.toRadians()
    let toLat = toLocation.coordinate.latitude.toRadians()
    let toLon = toLocation.coordinate.longitude.toRadians()

    let y = sin(toLon - fromLon) * cos(toLat)
    let x = cos(fromLat) * sin(toLat) - sin(fromLat) * cos(toLat) * cos(toLon - fromLon)
    return abs( atan2(y, x).toDegrees().remainder(dividingBy: 360) )
}
