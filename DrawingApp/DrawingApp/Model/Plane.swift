import Foundation
import UIKit

struct Plane {

    let factory: DrawingObjectFactory = DrawingObjectFactory()

    var drawingObject: [String: DrawingObject] = [:]

    mutating func addRectangle(frameWidth: Double, frameHeight: Double) {
        let rectangle = self.factory.createRandomRectangle(frameWidth: frameWidth, frameHeight: frameHeight)
        self.drawingObject[rectangle.id] = rectangle
        var userInfo: [AnyHashable : Any]? = [:]
        userInfo?["id"] = rectangle.id
        userInfo?["frame"] = rectangle.frame
        userInfo?["R"] = rectangle.R
        userInfo?["G"] = rectangle.G
        userInfo?["B"] = rectangle.B

        NotificationCenter.default.post(name: Notification.Name("AddRectangle"), object: nil, userInfo: userInfo)
    }

    mutating func addImage(frameWidth: Double, frameHeight: Double, image: UIImage) {
        let image = self.factory.createRandomImage(frameWidth: frameWidth, frameHeight: frameHeight, image: image)
        self.drawingObject[image.id] = image
        var userInfo: [AnyHashable : Any]? = [:]
        userInfo?["id"] = image.id
        userInfo?["frame"] = image.frame
        userInfo?["image"] = image.image

        NotificationCenter.default.post(name: Notification.Name("AddImage"), object: nil, userInfo: userInfo)
    }

    var totalObjectCount: Int {
        get {
            return self.drawingObject.count
        }
    }

    func setRectangleColor(id: String, R: UInt8, G: UInt8, B: UInt8) {
        (self.drawingObject[id] as? Rectangle)?.R = R
        (self.drawingObject[id] as? Rectangle)?.G = G
        (self.drawingObject[id] as? Rectangle)?.B = B
    }

    mutating func setObjectAlpha(id: String, alpha: Float) {
        self.drawingObject[id]!.frame.alpha = Int(alpha)
    }

    subscript(position: Point) -> String? {
        for (_, value) in self.drawingObject.reversed() {
            if value.isPointIncluded(position: position) == true {
                return value.id
            }
        }
        return nil
    }
}
