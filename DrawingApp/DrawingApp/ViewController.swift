import UIKit
import OSLog

protocol DrawingSectionDelegate {
    func rectangleDidAdd()
    func pictureDidAdd()
}

protocol StatusSectionDelegate: UITextFieldDelegate {
    func alphaDidChanged(alpha: Float)
}

class ViewController: UIViewController {
    
    var plane: Plane = Plane()

    var selectedRectangle: String?

    let imagePicker = UIImagePickerController()

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    private let drawingSection: DrawingSection = {
        let section = DrawingSection()
        section.translatesAutoresizingMaskIntoConstraints = false
        section.backgroundColor = .white
        return section
    }()
    
    private let statusSection: StatusSection = {
        let section = StatusSection()
        section.translatesAutoresizingMaskIntoConstraints = false
        section.backgroundColor = .systemGray4
        return section
    }()
    
    override func loadView() {
        self.view = MainView()
        
        let tapGestureRecognizer = UITapGestureRecognizer()
        tapGestureRecognizer.delegate = self
        self.drawingSection.addGestureRecognizer(tapGestureRecognizer)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.addSubview(self.drawingSection)
        self.view.addSubview(self.statusSection)
        
        self.drawingSection.delegate = self
        self.statusSection.delegate = self
        self.imagePicker.delegate = self

        let safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            self.drawingSection.topAnchor.constraint(equalTo: safeArea.topAnchor),
            self.drawingSection.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            self.drawingSection.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.drawingSection.trailingAnchor.constraint(equalTo: self.statusSection.leadingAnchor),
            
            self.statusSection.widthAnchor.constraint(equalToConstant: 300),
            self.statusSection.topAnchor.constraint(equalTo: safeArea.topAnchor),
            self.statusSection.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            self.statusSection.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(rectangleDidDraw(_:)),
            name: Notification.Name("UpdatePlane"),
            object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("UpdatePlane"), object: nil)
    }

    @objc func rectangleDidDraw(_ notification: Notification) {
        let userInfo = notification.userInfo!
        let id = userInfo["id"] as! String
        let frame = userInfo["frame"] as! Frame
        let RGB = userInfo["RGB"] as! [UInt8]
        os_log("Frame %@", "\(frame)")
        let rectangleView = UIView(frame: CGRect(x: frame.point.X, y: frame.point.Y, width: frame.size.Width, height: frame.size.Height))
        rectangleView.backgroundColor = UIColor(red: CGFloat(RGB[0])/255, green: CGFloat(RGB[1])/255, blue: CGFloat(RGB[2])/255, alpha: CGFloat(frame.alpha)/10)
        self.drawingSection.addRectangle(id: id, rectangleView: rectangleView)
    }
}

extension ViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        let CGPosition = touch.location(in: self.drawingSection)

        self.view.endEditing(true)

        if self.selectedRectangle != nil {
            self.drawingSection.setRectangleBorder(selectedRectangle: self.selectedRectangle!, state: BorderState.unselected)
        }

        guard let rectangle = self.plane[Point(X: CGPosition.x, Y: CGPosition.y)] else {
            self.selectedRectangle = nil
            self.statusSection.setUserInteractionEnabled(isEnable: false)
            return false
        }

        self.selectedRectangle = rectangle
        self.drawingSection.setRectangleBorder(selectedRectangle: self.selectedRectangle!, state: BorderState.selected)

        let color = self.drawingSection.getRectangleColor(id: rectangle)
        self.statusSection.setUserInteractionEnabled(isEnable: true)
        self.statusSection.setColor(color: color)
        self.statusSection.setAlpha(alpha: Float(color.cgColor.alpha))
        return true
    }
}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        if let newImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            print(newImage)
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
}

extension ViewController: DrawingSectionDelegate {
    func rectangleDidAdd() {
        plane.addRectangle(frameWidth: self.view.safeAreaLayoutGuide.layoutFrame.width - self.statusSection.frame.width, frameHeight: self.view.safeAreaLayoutGuide.layoutFrame.height)
    }

    func pictureDidAdd() {
        self.present(self.imagePicker, animated: true)
    }
}

extension ViewController: StatusSectionDelegate {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text!.remove(at: textField.text!.startIndex)
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let rectangle = self.selectedRectangle else { return }

        if textField.text?.count == 6 {
            let color = UIColor(hexRGB: textField.text!)
            let rgbColor = color!.rgbFloat

            self.drawingSection.setRectangleColor(id: rectangle, color: color)
            self.plane.setRectangleColor(id: rectangle, R: UInt8(rgbColor.red * 255.0), G: UInt8(rgbColor.green * 255.0), B: UInt8(rgbColor.blue * 255.0))

            textField.text = "#" + textField.text!
        } else {
            self.statusSection.setColor(color: self.drawingSection.getRectangleColor(id: rectangle))
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        if string.isEmpty {
            return true
        }

        guard textField.text?.count ?? 0 < 6 || string.count > 1 else {
            return false
        }

        if string[0].isHexDigit == false {
            return false
        } else if string[0].isLowercase {
            textField.insertText(string[0].uppercased())
            return false
        }
        
        return true
    }

    func alphaDidChanged(alpha: Float) {
        if let rectangle = self.selectedRectangle {
            self.drawingSection.setRectangleAlpha(id: rectangle, alpha: alpha)
            self.plane.setRectangleAlpha(id: rectangle, alpha: alpha)
        }
    }
}
