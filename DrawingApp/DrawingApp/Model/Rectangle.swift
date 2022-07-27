import Foundation

final class Rectangle: DrawingObject {
    let id: String
    var frame: Frame
    var R: UInt8
    var G: UInt8
    var B: UInt8

    init(id: String, size: Size, point: Point, R: UInt8, G: UInt8, B: UInt8, alpha: Int) {
        self.id = id
        self.frame = Frame(size: size, point: point, alpha: alpha)
        self.R = R
        self.G = G
        self.B = B
    }
}
