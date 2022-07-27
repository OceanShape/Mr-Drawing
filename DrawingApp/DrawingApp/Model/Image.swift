import Foundation
import UIKit

final class Image: DrawingObject {
    let image: UIImage

    init(id: String, size: Size, point: Point, image: UIImage, alpha: Int) {
        self.image = image
        super.init(id: id, size: size, point: point, alpha: alpha)
    }
}
