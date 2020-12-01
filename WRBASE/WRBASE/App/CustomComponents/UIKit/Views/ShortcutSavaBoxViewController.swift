import UIKit

class ShortcutSavaBoxViewController: BaseViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var card: LightboxCardView!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var titleLabel: CBKLabel!
    @IBOutlet weak var bodyLabel: CBKLabel!
    @IBOutlet weak var button: CBKButton!
    @IBOutlet var container: UIView!
    @IBOutlet weak var txShortcutName: CBKBaseTextField!
    public var imageIcon = UIImage()
    public var titleLabelText = "message"
    public var bodyLabelText = "body"
    public var buttonTitle = "button"
    public var shortcutName = ""
    
    public var actionTarget: (() ->())?
    
    // MARK: - Class Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    @objc func buttonTarget(){
        if let action = actionTarget, let name = txShortcutName.text, !name.isEmpty{
            shortcutName = name
            action()
        }
    }
    
    func setupViews() {
        image.image = imageIcon.withRenderingMode(.alwaysTemplate)
        titleLabel.text = titleLabelText
        bodyLabel.text = bodyLabelText
        button.setTitle(buttonTitle, for: .normal)
        image.tintColor = .blueCaixa1
        titleLabel.type = .lightboxTitle
        bodyLabel.type = .lightboxBody
        button.addTarget(self, action: #selector(buttonTarget), for: .touchUpInside)
    }
}
