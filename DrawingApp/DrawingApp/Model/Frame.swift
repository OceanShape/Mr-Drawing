import Foundation

struct Frame {
    let size: Size
    let point: Point
    let R: UInt8
    let G: UInt8
    let B: UInt8
    let alpha: Int
    
    init(size: Size, point: Point, R: UInt8, G: UInt8, B: UInt8, alpha: Int) {
        self.size = size
        self.point = point
        self.R = R
        self.G = G
        self.B = B
        self.alpha = alpha
    }
}
