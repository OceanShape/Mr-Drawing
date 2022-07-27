import Foundation
import UIKit

final class Image: DrawingObject {
    let id: String
    var frame: Frame
    let image: UIImage

    init(id: String, size: Size, point: Point, image: UIImage, alpha: Int) {
        self.id = id
        self.frame = Frame(size: size, point: point, alpha: alpha)
        self.image = image
    }
}
