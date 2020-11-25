//
import Foundation
import UIKit

public class TitleNSubtitleView: UIView {
    
    @IBOutlet weak var header: UILabel!
    @IBOutlet weak var bodyMessage: UILabel!
    @IBOutlet var containerView: UIView!
    @IBOutlet weak var image: UIImageView!
    
    public var img: UIImage = UIImage() {
        didSet {
            image.image = img
        }
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        if image.image != nil {
            image.isHidden = false
        }
    }
    
    
    public func commonInit() {
        let nib = UINib(nibName: "TitleNSubtitleView", bundle: nil)
        nib.instantiate(withOwner: self, options: nil)
        containerView.frame = bounds
        addSubview(containerView)
        setupView()
        image.isHidden = true
    }
    
    func setupView() {
        bodyMessage.lineBreakMode = .byTruncatingTail
        bodyMessage.adjustsFontSizeToFitWidth = true
        bodyMessage.minimumScaleFactor = 10.0
    }
    
}
