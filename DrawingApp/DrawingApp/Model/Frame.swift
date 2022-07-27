import Foundation

struct Frame {
    let size: Size
    let point: Point
    let alpha: Int
    
    init(size: Size, point: Point, alpha: Int) {
        self.size = size
        self.point = point
        self.alpha = alpha
    }
}
