//
import Foundation
import UIKit

public class CBKTextField: UIView {
    public var textField: CBKBaseTextField?
    public var iconView: UIView?
    public var icon: UIImageView?
    
    public override init(frame: CGRect){
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    func setupViews() {
        textField = CBKBaseTextField()
        iconView = UIView(frame: .zero)
        
        if let textField = textField, let iconView = iconView, let icon = icon {

            textField.translatesAutoresizingMaskIntoConstraints = false
            iconView.translatesAutoresizingMaskIntoConstraints = false
            
            icon.translatesAutoresizingMaskIntoConstraints = false
            
            icon.tintColor = .blueCaixa3
            icon.contentMode = .scaleAspectFit
            
            addSubview(textField)
            iconView.addSubview(icon)
            addSubview(iconView)
            
            NSLayoutConstraint.activate([
                textField.topAnchor.constraint(equalTo: topAnchor),
                textField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
                textField.bottomAnchor.constraint(equalTo: bottomAnchor),
                
                textField.widthAnchor.constraint(equalToConstant: (frame.width * 0.65)),
                
                iconView.leadingAnchor.constraint(equalTo: textField.trailingAnchor),
                iconView.topAnchor.constraint(equalTo: topAnchor),
                iconView.trailingAnchor.constraint(equalTo: trailingAnchor),
                iconView.bottomAnchor.constraint(equalTo: bottomAnchor),
                
                icon.leadingAnchor.constraint(equalTo: iconView.leadingAnchor, constant: 5),
                icon.topAnchor.constraint(equalTo: iconView.topAnchor, constant: 10),
                icon.trailingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: -5),
                icon.bottomAnchor.constraint(equalTo: iconView.bottomAnchor, constant: -10),
            ])
            
            backgroundColor = .blueCaixa3
            textField.backgroundColor = backgroundColor
            layer.borderWidth = 1.0
            layer.borderColor = UIColor.clear.cgColor
            layer.cornerRadius = 12.0
            layer.shadowColor = UIColor.black.cgColor
            layer.shadowOpacity = 0.2
            layer.shadowRadius = 12.0
        }
    }
}
