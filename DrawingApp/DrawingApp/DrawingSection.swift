import UIKit

class DrawingSection: UIView {
    
    var delegate: DrawingSectionDelegate?
    
    var rectangle: [String: UIView] = [:]

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
        button.addTarget(self, action: #selector(buttonTouched), for: .touchDown)
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
        
        NSLayoutConstraint.activate([
            self.drawingView.topAnchor.constraint(equalTo: self.topAnchor),
            self.drawingView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.drawingView.leadingAnchor.constraint(equalTo: leadingAnchor),
            self.drawingView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            self.addRectangleButton.widthAnchor.constraint(equalToConstant: 100),
            self.addRectangleButton.heightAnchor.constraint(equalToConstant: 100),
            self.addRectangleButton.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.addRectangleButton.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])
    }

    func addRectangle(id: String, rectangleView: UIView) {
        self.rectangle[id] = rectangleView
        self.drawingView.addSubview(rectangleView)
    }
    
    func setRectangleBorder(selectedRectangle: String, state: BorderState) {
        switch state {
        case .selected:
            self.rectangle[selectedRectangle]!.layer.borderWidth = CGFloat(5.0)
            self.rectangle[selectedRectangle]!.layer.borderColor = CGColor(red: 0.0, green: 0.0, blue: 1.0, alpha: 1.0)
        case .unselected:
            self.rectangle[selectedRectangle]!.layer.borderWidth = CGFloat(0.0)
        }
    }

    func setRectangleColor(id: String, color: UIColor?) {
        rectangle[id]?.backgroundColor = color?.withAlphaComponent(rectangle[id]?.backgroundColor?.alphaFloat ?? 1.0)
    }

    func setRectangleAlpha(id: String, alpha: Float) {
        let color = self.rectangle[id]!.backgroundColor!.rgbFloat
        let r = color.red
        let g = color.green
        let b = color.blue
        self.rectangle[id]!.backgroundColor = UIColor(red: r, green: g, blue: b, alpha: CGFloat(alpha / 10.0))
    }

    func getRectangleColor(id: String) -> UIColor {
        return self.rectangle[id]?.backgroundColor! ?? UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
    }

    @objc func buttonTouched() {
        self.delegate?.rectangleDidAdd()
    }
}
