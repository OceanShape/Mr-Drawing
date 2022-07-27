import Foundation

struct Frame {
    var size: Size
    var point: Point
    var _alpha: Int = 0
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
    
    init(size: Size, point: Point, alpha: Int) {
        self.size = size
        self.point = point
        self.alpha = alpha
    }
}
