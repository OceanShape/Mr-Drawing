import Foundation
import UIKit

final class Image: DrawingObject {
    let id: String
    var size: Size
    var point: Point
    var _alpha: Int
    var alpha: Int
    let _image: UIImage

    init(id: String, size: Size, point: Point, image: UIImage, alpha: Int) {
        self.id = id
        self.size = size
        self.point = point
        self._alpha = 5
        self.alpha = alpha
        self._image = image
    }

    var image: UIImage {
        return self._image
    }
}
