import Foundation

final class Rectangle: DrawingObject {
    var R: UInt8
    var G: UInt8
    var B: UInt8

    init(id: String, size: Size, point: Point, R: UInt8, G: UInt8, B: UInt8, alpha: Int) {
        self.R = R
        self.G = G
        self.B = B
        super.init(id: id, size: size, point: point, alpha: alpha)
    }
    
    var frame: Frame {
        return Frame(size: self.size, point: self.point, R: self.R, G: self.G, B: self.B, alpha: self.alpha)
    }
}
