import Foundation

class RectangleFactory {
    let idElement: String = "abcdefghijklmnopqrstuvwxyz0123456789"

    func createRectangle(size: Size, point: Point, R: UInt8, G: UInt8, B: UInt8, alpha: Int) -> Rectangle {
        return Rectangle(id: getRandomId(), size: size, point: point, R: UInt8(R), G: UInt8(G), B: UInt8(B), alpha: alpha)
    }
    
    func createRandomRectangle(frameWidth: Double, frameHeight: Double) -> Rectangle {
        let x = Int.random(in: 0..<Int(frameWidth))
        let y = Int.random(in: 0..<Int(frameHeight))
        let width = Int.random(in: 1...Int(frameWidth) - x)
        let height = Int.random(in: 1...Int(frameHeight) - y)

        return createRectangle(size: Size(width: Double(width), height: Double(height)), point: Point(X: Double(x), Y: Double(y)), R: UInt8(Int.random(in: 0..<255)), G: UInt8(Int.random(in: 0..<255)), B: UInt8(Int.random(in: 0..<255)), alpha: 10)
    }
    
    func getRandomId() -> String {
        var id = String((0 ..< 9).map{ _ in idElement.randomElement()! })
        id.insert("-", at: id.index(id.startIndex, offsetBy: 3))
        id.insert("-", at: id.index(id.startIndex, offsetBy: 7))
        return id
    }
}
