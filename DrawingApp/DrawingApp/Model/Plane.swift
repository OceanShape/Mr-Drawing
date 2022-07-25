import Foundation

struct Plane {

    let factory: RectangleFactory = RectangleFactory()

    var rectangle: [String: Rectangle] = [:]

    mutating func addRectangle(frameWidth: Double, frameHeight: Double) {
        let rectangle = self.factory.createRandomRectangle(frameWidth: frameWidth, frameHeight: frameHeight)
        self.rectangle[rectangle.id] = rectangle
        var userInfo: [AnyHashable : Any]? = [:]
        print(rectangle)
        userInfo?["id"] = rectangle.id
        userInfo?["frame"] = rectangle.frame

        NotificationCenter.default.post(name: Notification.Name("UpdatePlane"), object: nil, userInfo: userInfo)
    }

    var totalRectangleCount: Int {
        get {
            return self.rectangle.count
        }
    }

    func setRectangleColor(id: String, R: UInt8, G: UInt8, B: UInt8) {
        rectangle[id]?.R = R
        rectangle[id]?.G = G
        rectangle[id]?.B = B
    }

    func setRectangleAlpha(id: String, alpha: Float) {
        rectangle[id]?.alpha = Int(alpha)
    }

    subscript(position: Point) -> String? {
        for (_, value) in self.rectangle.reversed() {
            if value.isPointIncluded(position: position) == true {
                return value.id
            }
        }
        return nil
    }
}
