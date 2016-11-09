import UIKit

extension UIColor {

    convenience init(r: CGFloat, g: CGFloat, b: CGFloat) {
        self.init(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: 1)
    }

    convenience init(rgb: CGFloat) {
        self.init(r: rgb, g: rgb, b: rgb)
    }

    func withAlpha(_ alpha: CGFloat) -> UIColor {
        return withAlphaComponent(alpha)
    }

    func adjust(_ value: CGFloat) -> UIColor {
        return adjust(value, green: value, blue: value)
    }

    func adjust(_ red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor{
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        getRed(&r, green: &g, blue: &b, alpha: &a)
        return UIColor(red: r+red, green: g+green, blue: b+blue, alpha: a)
    }
}
