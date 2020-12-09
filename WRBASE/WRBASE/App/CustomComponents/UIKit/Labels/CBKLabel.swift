//
import Foundation
import UIKit

enum LabelType: Int {
    case lightboxTitle,
         lightboxBody,
         pickerView
}

class CBKLabel: UILabel {
    
    var type: LabelType = .lightboxTitle {
        didSet {
            setupLabel()
        }
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setupLabel()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupLabel()
    }
    
    func setupLabel() {
        switch type {
        case .lightboxTitle:
            font = .openSansRegular(size: 18.0)
            textColor = .textDark
            
        case .lightboxBody:
            font = .openSansRegular(size: 15.0)
            textColor = .textLight
        
        case .pickerView:
            font = .openSansRegular(size: 22)
            textColor = .genericBlack
        }
    }
    
    
    
    
    
}
