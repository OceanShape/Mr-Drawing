import Foundation

struct Size {
    private(set) var Width: Double
    private(set) var Height: Double

    init(width: Double, height: Double) {
        self.Width = width
        self.Height = height
    }
}
