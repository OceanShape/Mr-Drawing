import Foundation

class Rectangle : CustomStringConvertible {
    let id: String
    private var _alpha: Int = 10
    var size: Size
    var point: Point
    var R: UInt8
    var G: UInt8
    var B: UInt8
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

    init(id: String, size: Size, point: Point, R: UInt8, G: UInt8, B: UInt8, alpha: Int) {
        self.id = id
        self.size = size
        self.point = point

        self.R = R
        self.G = G
        self.B = B
        self.alpha = alpha
    }
    
    var frame: Frame {
        return Frame(size: self.size, point: self.point, R: self.R, G: self.G, B: self.B, alpha: self.alpha)
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
    
    var description: String {
        return "(\(id)), X:\(point.X),Y:\(point.Y), W\(size.Width), H\(size.Height), R:\(R), G:\(G), B:\(B), alpha: \(alpha)"
    }
}

extension Rectangle: Hashable {
    static func == (lhs: Rectangle, rhs: Rectangle) -> Bool {
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
