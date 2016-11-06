import CoreGraphics

extension CGFloat {

    func toRadians() -> CGFloat {
        return self * .pi / 180.0
    }

    func toDegrees() -> CGFloat {
        return self * 180.0 / .pi
    }
}
