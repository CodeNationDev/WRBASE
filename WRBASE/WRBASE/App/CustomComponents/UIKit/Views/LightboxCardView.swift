//
import Foundation
import UIKit


public class LightboxCardView:UIView {
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    func setupView() {
        backgroundColor = .genericWhite
        layer.cornerRadius = 4.0
        layer.shadowColor = UIColor.genericBlack.cgColor
        layer.shadowOpacity = 0.2
        layer.shadowOffset = CGSize(width: 0.0, height: 10.0)
        layer.shadowRadius = 15.0
    }
    
}
