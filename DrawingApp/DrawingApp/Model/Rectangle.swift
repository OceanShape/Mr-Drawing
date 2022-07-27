import Foundation

final class Rectangle: DrawingObject {
    let id: String
    var size: Size
    var point: Point
    var _alpha: Int
    var alpha: Int
    var R: UInt8
    var G: UInt8
    var B: UInt8

    init(id: String, size: Size, point: Point, R: UInt8, G: UInt8, B: UInt8, alpha: Int) {
        self.id = id
        self.size = size
        self.point = point
        self._alpha = 5
        self.alpha = alpha
        self.R = R
        self.G = G
        self.B = B
    }
    
    var frame: Frame {
        return Frame(size: self.size, point: self.point, alpha: self.alpha)
    }

    var RGB: [UInt8] {
        return [self.R, self.G, self.B]
    }
}
