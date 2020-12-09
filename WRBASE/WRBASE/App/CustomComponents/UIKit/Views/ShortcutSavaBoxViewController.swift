import UIKit

class ShortcutSavaBoxViewController: BaseViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var card: LightboxCardView!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var titleLabel: CBKLabel!
    @IBOutlet weak var bodyLabel: CBKLabel!
    @IBOutlet weak var button1: CBKButton!
    @IBOutlet weak var button2: CBKButton!
    @IBOutlet var container: UIView!
    @IBOutlet weak var txShortcutName: CBKBaseTextField!
    public var imageIcon = UIImage()
    public var titleLabelText = "message"
    public var bodyLabelText = "body"
    public var button1Title: String? {
        didSet {
            setupViews()
        }
    }
    public var button2Title: String? {
        didSet {
            setupViews()
        }
    }
    public var shortcutName = ""
    
    public var actionButton1Target: (() ->())?
    public var actionButton2Target: (() ->())?
    
    // MARK: - Class Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    @objc func button1Target(){
        if let action = actionButton1Target, let name = txShortcutName.text, !name.isEmpty{
            shortcutName = name
            action()
        }
    }
    
    @objc func button2Target(){
        if let action = actionButton2Target {
            action()
        }
    }
    
    func setupViews() {
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.8)
        image.image = imageIcon.withRenderingMode(.alwaysTemplate)
        titleLabel.text = titleLabelText
        bodyLabel.text = bodyLabelText
        image.tintColor = .blueCaixa1
        titleLabel.type = .lightboxTitle
        bodyLabel.type = .lightboxBody
        if let button1 = button1 {
            button1.setTitle(button1Title, for: .normal)
            button1.addTarget(self, action: #selector(button1Target), for: .touchUpInside)
        }
        
        if let button2 = button2, let button2Title = button2Title  {
            button2.isHidden = false
            button2.setTitle(button2Title, for: .normal)
            button2.addTarget(self, action: #selector(button2Target), for: .touchUpInside)
        }
        
    }
}
