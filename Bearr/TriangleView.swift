import UIKit

final class TriangleView: UIView {

    fileprivate let color: UIColor

    init(color: UIColor) {
        self.color = color
        super.init(frame: CGRect.zero)
        backgroundColor = .clear
        layer.allowsEdgeAntialiasing = true
    }

    required init?(coder aDecoder: NSCoder) { fatalError() }

    override func draw(_ rect: CGRect) {
        let ctx = UIGraphicsGetCurrentContext()
        ctx!.beginPath()
        ctx!.move(to: CGPoint(x: rect.midX, y: rect.minY))  // top mid
        ctx!.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))  // bottom right
        ctx!.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))  // bottom left
        ctx!.closePath()

        ctx!.setFillColor(color.cgColor)
        ctx!.fillPath()
    }
}
