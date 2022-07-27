import Foundation

protocol DrawingObject {
    var id: String { get }
    var frame: Frame { get set }
}

extension DrawingObject {
    func isPointIncluded(position: Point) -> Bool {
        let point = self.frame.point
        let size = self.frame.size
        let X1: Double = point.X
        let X2: Double = point.X + size.Width
        let Y1: Double = point.Y
        let Y2: Double = point.Y + size.Height
        if (X1 <= position.X && position.X <= X2) && (Y1 <= position.Y && position.Y <= Y2) {
            return true
        }
        return false
    }
}
