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

    var selectedObject: String?

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
            name: Notification.Name("AddRectangle"),
            object: nil)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(imageDidDraw(_:)),
            name: Notification.Name("AddImage"),
            object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("AddRectangle"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("AddImage"), object: nil)
    }

    @objc func rectangleDidDraw(_ notification: Notification) {
        let userInfo = notification.userInfo!
        let id = userInfo["id"] as! String
        let frame = userInfo["frame"] as! Frame
        let R = userInfo["R"] as! UInt8
        let G = userInfo["G"] as! UInt8
        let B = userInfo["B"] as! UInt8
        os_log("id: %@, Frame: %@, RGB: %@", "\(id)", "\(frame)", "\(R)", "\(G)", "\(B)")
        let view = UIView(frame: CGRect(x: frame.point.X, y: frame.point.Y, width: frame.size.Width, height: frame.size.Height))
        view.backgroundColor = UIColor(red: CGFloat(R)/255, green: CGFloat(G)/255, blue: CGFloat(B)/255, alpha: CGFloat(1.0))
        view.alpha = CGFloat(frame.alpha)/10
        self.drawingSection.addObject(id: id, objectView: view)
    }
    
    @objc func imageDidDraw(_ notification: Notification) {
        let userInfo = notification.userInfo!
        let id = userInfo["id"] as! String
        let frame = userInfo["frame"] as! Frame
        let image = userInfo["image"] as! UIImage
        
        os_log("id: %@, Frame: %@, image: %@", "\(id)", "\(frame)", "\(image)")
        let imageView = UIImageView(frame: CGRect(x: frame.point.X, y: frame.point.Y, width: frame.size.Width, height: frame.size.Height))
        imageView.image = image
        imageView.alpha = CGFloat(frame.alpha)/10
        self.drawingSection.addObject(id: id, objectView: imageView)
    }
}

extension ViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        let CGPosition = touch.location(in: self.drawingSection)

        self.view.endEditing(true)

        if self.selectedObject != nil {
            self.drawingSection.setObjectBorder(selectedObject: self.selectedObject!, state: BorderState.unselected)
        }

        guard let object = self.plane[Point(X: CGPosition.x, Y: CGPosition.y)] else {
            self.selectedObject = nil
            self.statusSection.setColorStatusEnabled(isEnable: false)
            self.statusSection.setAlphaStatusEnabled(isEnable: false)
            return false
        }


        self.selectedObject = object
        self.drawingSection.setObjectBorder(selectedObject: self.selectedObject!, state: BorderState.selected)

        self.statusSection.setAlphaStatusEnabled(isEnable: true)
        self.statusSection.setAlpha(alpha: self.drawingSection.getObjectAlpha(id: object))

        if let color = self.drawingSection.getRectangleColor(id: object) {
            self.statusSection.setColorStatusEnabled(isEnable: true)
            self.statusSection.setColor(color: color)
        } else {
            self.statusSection.setColorStatusEnabled(isEnable: false)
        }

        return true
    }
}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            plane.addImage(frameWidth: self.view.safeAreaLayoutGuide.layoutFrame.width - self.statusSection.frame.width, frameHeight: self.view.safeAreaLayoutGuide.layoutFrame.height, image: image)
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
        guard let rectangle = self.selectedObject else { return }

        if textField.text?.count == 6 {
            let color = UIColor(hexRGB: textField.text!)
            let rgbColor = color!.rgbFloat

            self.drawingSection.setRectangleColor(id: rectangle, color: color)
            self.plane.setRectangleColor(id: rectangle, R: UInt8(rgbColor.red * 255.0), G: UInt8(rgbColor.green * 255.0), B: UInt8(rgbColor.blue * 255.0))

            textField.text = "#" + textField.text!
        } else {
            self.statusSection.setColor(color: self.drawingSection.getRectangleColor(id: rectangle)!)
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
        self.drawingSection.setObjectAlpha(id: self.selectedObject!, alpha: alpha)
        self.plane.setObjectAlpha(id: self.selectedObject!, alpha: alpha)
    }
}
