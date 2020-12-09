//
import Foundation
import UIKit

enum ButtonTypeAspect: Int {
    case lightbox, pickerView
}

class CBKButton: UIButton {
    
    public var buttonTypeAspect: ButtonTypeAspect = .lightbox {
        didSet {
            setupButton()
        }
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
      setupButton()
    }
    
    func setupButton() {
        switch buttonTypeAspect {
        case .lightbox:
            titleLabel!.font = .openSansSemiBold(size: 15.0)
            setTitleColor(.blueCaixa1, for: .normal)
        case .pickerView:
            titleLabel!.font = .openSansSemiBold(size: 15.0)
            setTitleColor(.genericWhite, for: .normal)
            backgroundColor = .blueCaixa1
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupButton()
    }
}
