import CoreLocation
import RxSwift

class Navigator: NSObject {

    fileprivate let locationManager = CLLocationManager()
    fileprivate let magneticHeadingSubject = BehaviorSubject<CLLocationDirection>(value: 0)
    fileprivate let destinationHeadingSubject = BehaviorSubject<CLLocationDirection>(value: 0)
    fileprivate let currentLocationSubject = BehaviorSubject<CLLocationCoordinate2D?>(value: nil)
    fileprivate let speedSubject = BehaviorSubject<CLLocationSpeed>(value: 0)

    var magneticHeading: Observable<CLLocationDirection> {
        return magneticHeadingSubject.asObserver()
    }
    var destinationHeading: Observable<CLLocationDirection> {
        return Observable.combineLatest(magneticHeadingSubject, destinationHeadingSubject) { $0 + $1 }
    }
    var currentLocation: Observable<CLLocationCoordinate2D> {
        return currentLocationSubject.asObservable().filter { $0 != nil } .map { $0! }
    }
    var speed: Observable<CLLocationSpeed> {
        return speedSubject.asObservable().map { max($0, 0) }
    }

    fileprivate var destination: CLLocation = CLLocation(latitude: 50.750142, longitude: -1.806269)

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
        magneticHeadingSubject.onNext(-newHeading.magneticHeading)
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let currentLocation = locations.last {
            currentLocationSubject.onNext(currentLocation.coordinate)
            speedSubject.onNext(currentLocation.speed)
            destinationHeadingSubject.onNext(bearing(fromLocation: currentLocation, toLocation: destination))
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
