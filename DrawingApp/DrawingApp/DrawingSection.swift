import UIKit

class DrawingSection: UIView {
    
    var delegate: DrawingSectionDelegate?

    var drawingObject: [String: UIView] = [:]

    private let drawingView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()

    private let addRectangleButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .systemGray4
        button.layer.cornerRadius = 20
        button.setImage(UIImage(named: "addRectangle.png"), for: .normal)
        button.addTarget(self, action: #selector(addRectangleButtonTouched), for: .touchDown)
        return button
    }()

    private let addPictureButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .systemGray4
        button.layer.cornerRadius = 20
        button.setImage(UIImage(named: "addPicture.png"), for: .normal)
        button.addTarget(self, action: #selector(addPictureButtonTouched), for: .touchDown)
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUpView()
    }
    
    func setUpView() {
        self.addSubview(drawingView)
        self.addSubview(addRectangleButton)
        self.addSubview(addPictureButton)
        
        NSLayoutConstraint.activate([
            self.drawingView.topAnchor.constraint(equalTo: self.topAnchor),
            self.drawingView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.drawingView.leadingAnchor.constraint(equalTo: leadingAnchor),
            self.drawingView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            self.addRectangleButton.widthAnchor.constraint(equalToConstant: 100),
            self.addRectangleButton.heightAnchor.constraint(equalToConstant: 100),
            self.addRectangleButton.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.addRectangleButton.rightAnchor.constraint(equalTo: self.centerXAnchor),

            self.addPictureButton.widthAnchor.constraint(equalToConstant: 100),
            self.addPictureButton.heightAnchor.constraint(equalToConstant: 100),
            self.addPictureButton.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.addPictureButton.leftAnchor.constraint(equalTo: self.centerXAnchor)
        ])
    }

    func addObject(id: String, objectView: UIView) {
        self.drawingObject[id] = objectView
        self.drawingView.addSubview(objectView)
    }
    
    func setObjectBorder(selectedObject: String, state: BorderState) {
        switch state {
        case .selected:
            self.drawingObject[selectedObject]!.layer.borderWidth = CGFloat(5.0)
            self.drawingObject[selectedObject]!.layer.borderColor = CGColor(red: 0.0, green: 0.0, blue: 1.0, alpha: 1.0)
        case .unselected:
            self.drawingObject[selectedObject]!.layer.borderWidth = CGFloat(0.0)
        }
    }

    func getRectangleColor(id: String) -> UIColor? {
        return self.drawingObject[id]?.backgroundColor
    }

    func getObjectAlpha(id: String) -> Float {
        return Float(self.drawingObject[id]?.alpha ?? 1.0)
    }

    func setRectangleColor(id: String, color: UIColor?) {
        guard drawingObject[id] as? UIImageView == nil else { return }
        drawingObject[id]?.backgroundColor = color?.withAlphaComponent(drawingObject[id]?.backgroundColor?.alphaFloat ?? 1.0)
    }

    func setObjectAlpha(id: String, alpha: Float) {
        self.drawingObject[id]!.alpha = CGFloat(alpha)/10
    }

    @objc func addRectangleButtonTouched() {
        self.delegate?.rectangleDidAdd()
    }

    @objc func addPictureButtonTouched() {
        self.delegate?.pictureDidAdd()
    }
}
