import Foundation

protocol DrawingObject {
    var id: String { get }
    var size: Size { get set }
    var point: Point { get set }
    var _alpha: Int { get set }
    var alpha: Int { get set }
    var frame: Frame { get }
}

extension DrawingObject {
    var frame: Frame {
        get {
            return Frame(size: size, point: point, alpha: alpha)
        }
    }
    var alpha: Int {
        get {
            return self._alpha
        }
        set {
            switch newValue {
            case ...0 :
                self._alpha = 0
            case 10...:
                self._alpha = 10
            default:
                self._alpha = newValue
            }
        }
    }
    func isPointIncluded(position: Point) -> Bool {
        let X1: Double = self.point.X
        let X2: Double = self.point.X + self.size.Width
        let Y1: Double = self.point.Y
        let Y2: Double = self.point.Y + self.size.Height
        if (X1 <= position.X && position.X <= X2) && (Y1 <= position.Y && position.Y <= Y2) {
            return true
        }
        return false
    }
}
