import CoreGraphics

extension CGFloat {

    func toRadians() -> CGFloat {
        return self * .pi / 180.0
    }

    func toDegrees() -> CGFloat {
        return self * 180.0 / .pi
    }
}


extension Double {

    func toRadians() -> Double {
        return self * .pi / 180
    }

    func toDegrees() -> Double {
        return self * 180 / .pi
    }
}
