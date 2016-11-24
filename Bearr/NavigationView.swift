import UIKit
import MapKit

class NavigationView: UIView {

    lazy var circleView: UIView = {
        let view = UIView()
        view.layer.borderWidth = 10
        view.layer.borderColor = UIColor.neonBlue.cgColor
        return view
    }()

    let mapView = MKMapView()

    let destinationPointerView = TriangleView(color: .neonBlue)
    let northPointerView = TriangleView(color: .white)

    lazy var northLabel: UILabel = {
        let label = UILabel()
        label.text = "N"
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()

    lazy var speedLabel: UILabel = {
        let label = UILabel()
        label.font = label.font.withSize(25)
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()

    var radius: CGFloat {
        return (min(bounds.width, bounds.height) / 2) - 40
    }

    let destinationPointerSize = CGSize(width: 60, height: 30)
    let northPointerSize = CGSize(width: 40, height: 20)
    let span: CLLocationDegrees = 0.025

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(northLabel)
        addSubview(speedLabel)
        addSubview(destinationPointerView)
        addSubview(northPointerView)
        addSubview(circleView)
        circleView.addSubview(mapView)
        circleView.clipsToBounds = true
        backgroundColor = .darkBackground
        mapView.showsUserLocation = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        // TODO: Use Layout Constraints
        circleView.frame = CGRect(x: bounds.midX - radius, y: bounds.midY - radius, width: radius*2, height: radius*2)
        circleView.layer.cornerRadius = radius
        mapView.frame = circleView.bounds

        northPointerView.bounds = CGRect(origin: .zero, size: northPointerSize)
        northPointerView.center = CGPoint(x: 50, y: 50)
        northLabel.bounds = CGRect(origin: .zero, size: CGSize(width: 50, height: 50))
        northLabel.center = CGPoint(x: 50, y: 80)

        destinationPointerView.bounds = CGRect(origin: .zero, size: destinationPointerSize)
        destinationPointerView.center = center
        destinationPointerView.layer.anchorPoint = CGPoint(x: 0.5, y: 1)

        speedLabel.bounds = CGRect(x: 0, y: 0, width: 100, height: 100)
        speedLabel.center = CGPoint(x: center.x, y: bounds.height - 50)
    }

    func set(location: CLLocationCoordinate2D) {
        let region = MKCoordinateRegion(center: location, span: MKCoordinateSpan(latitudeDelta: span, longitudeDelta: span))
        mapView.setRegion(region, animated: true)
    }

    func set(destinationHeading heading: Double) {
        animate(view: destinationPointerView, heading: heading)
    }

    func set(northHeading heading: Double) {
        northPointerView.transform = CGAffineTransform.identity.rotated(by: CGFloat(heading).toRadians())
    }

    private func animate(view: UIView, heading: Double, offset: CGFloat = 0) {
        let absHeading = abs(heading)
        let delta = absHeading > 180 ? 360 - absHeading : absHeading
        let scale = pow(((360 - delta) / 360), 2)
        view.transform = CGAffineTransform.identity
            .rotated(by: CGFloat(heading).toRadians())
            .translatedBy(x: 0, y: -radius + 2)
            .scaledBy(x: CGFloat(scale), y: CGFloat(scale))
    }
}
