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

    let pointerView = TriangleView(color: .neonBlue)
    let northPointerView = TriangleView(color: .white)

    var radius: CGFloat {
        return (min(bounds.width, bounds.height) / 2) - 40
    }

    let northPointerSize = CGSize(width: 40, height: 20)

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(pointerView)
        addSubview(northPointerView)
        addSubview(circleView)
        circleView.addSubview(mapView)
        circleView.clipsToBounds = true
        backgroundColor = .darkBackground
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        circleView.frame = CGRect(x: bounds.midX - radius, y: bounds.midY - radius, width: radius*2, height: radius*2)
        circleView.layer.cornerRadius = radius
        mapView.frame = circleView.bounds

        northPointerView.bounds = CGRect(x: 0, y: 0, width: northPointerSize.width, height: northPointerSize.height)
        northPointerView.center = CGPoint(x: 50, y: 50)

        pointerView.bounds = CGRect(x: 0, y: 0, width: 60, height: 30)
        pointerView.center = center
        pointerView.layer.anchorPoint = CGPoint(x: 0.5, y: 1)
    }

    func updatePointer(bearing: Double) {
        animate(view: pointerView, bearing: bearing)
    }

    func updateNorthPointer(bearing: Double) {
        northPointerView.transform = CGAffineTransform.identity.rotated(by: CGFloat(bearing).toRadians())
    }

    private func animate(view: UIView, bearing: Double, offset: CGFloat = 0) {
        let absBearing = abs(bearing)
        let delta = absBearing > 180 ? 360 - absBearing : absBearing
        let scale = pow(((360 - delta) / 360), 2)
        view.transform = CGAffineTransform.identity
            .rotated(by: CGFloat(bearing).toRadians())
            .translatedBy(x: 0, y: -radius + 2)
            .scaledBy(x: CGFloat(scale), y: CGFloat(scale))
    }
}
