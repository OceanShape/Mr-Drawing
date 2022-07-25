import UIKit

extension UIColor {
    var alphaFloat: CGFloat {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        return alpha
    }
    
    var rgbFloat: (red: CGFloat, green: CGFloat, blue: CGFloat) {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        return (red, green, blue)
    }

    var htmlRGBColor: String {
        return String(format: "#%02X%02X%02X", Int(rgbFloat.red * 255), Int(rgbFloat.green * 255), Int(rgbFloat.blue * 255))
    }

    convenience init?(hexRGB: String) {
        let red, green, blue, alpha: CGFloat
        
        for c in hexRGB {
            if c.isHexDigit == false {
                return nil
            }
        }

        var rgbValue: UInt64 = 0
        Scanner(string: hexRGB).scanHexInt64(&rgbValue)
        red = CGFloat((rgbValue & 0xff0000) >> 16) / 255.0
        green = CGFloat((rgbValue & 0x00ff00) >> 8) / 255.0
        blue = CGFloat(rgbValue & 0x0000ff) / 255.0
        alpha = CGFloat(1.0)
        self.init(red: red, green: green, blue: blue, alpha: alpha)
        return
    }
}
