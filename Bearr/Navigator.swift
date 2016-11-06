import CoreLocation

class Navigator {

    var bearing: Double = 0
}

func bearing(fromLocation: CLLocation, toLocation: CLLocation) -> CLLocationDirection {

    let fromLat = fromLocation.coordinate.latitude.toRadians()
    let fromLon = fromLocation.coordinate.longitude.toRadians()
    let toLat = toLocation.coordinate.latitude.toRadians()
    let toLon = toLocation.coordinate.longitude.toRadians()

    let y = sin(toLon - fromLon) * cos(toLat)
    let x = cos(fromLat) * sin(toLat) - sin(fromLat) * cos(toLat) * cos(toLon - fromLon)
    return atan2(y, x).toDegrees().truncatingRemainder(dividingBy: 360)
}
