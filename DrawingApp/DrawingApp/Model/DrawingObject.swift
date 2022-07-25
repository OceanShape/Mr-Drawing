import Foundation

class DrawingObject: CustomStringConvertible {
    let id: String
    private var _alpha: Int = 10
    var size: Size
    var point: Point
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

    init(id: String, size: Size, point: Point, alpha: Int) {
        self.id = id
        self.size = size
        self.point = point
        self.alpha = alpha
    }
    
    var description: String {
        return "(\(id)), X:\(point.X),Y:\(point.Y), W\(size.Width), H\(size.Height), alpha: \(alpha)"
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

extension DrawingObject: Hashable {
    static func == (lhs: DrawingObject, rhs: DrawingObject) -> Bool {
        return lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(size.Width)
        hasher.combine(size.Height)
        hasher.combine(point.X)
        hasher.combine(point.Y)
    }
}
