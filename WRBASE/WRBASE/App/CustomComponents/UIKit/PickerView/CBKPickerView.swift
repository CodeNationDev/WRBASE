//
import Foundation
import UIKit

public protocol CBKPickerViewDelegate {
    func didSelectOption(item: (String,Int))
}

public class CBKPickerView: UIPickerView, UIPickerViewDelegate {
    
    var collection: [(String, Int)]? = []
    public var cbkDelegate: CBKPickerViewDelegate?
  
    public init(items: [(String, Int)]) {
        super.init(frame: .zero)
        self.collection = items
        setupView()
        delegate = self
        dataSource = self
        
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    func setupView() {
        backgroundColor = .genericWhite
    }
}

extension CBKPickerView: UIPickerViewDataSource {
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        collection!.count
    }
    
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        cbkDelegate?.didSelectOption(item: (collection![row].0, collection![row].1))
    }
    
    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        collection?[row].0
    }
    
    public func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        55
    }
    
    public func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        let label: CBKLabel = {
            let label = CBKLabel(frame: CGRect(x: 0, y: 0, width: bounds.maxX, height: 50))
            label.type = .pickerView
            label.text = collection?[row].0
            label.textAlignment = .center
            return label
        }()
        
        return label
    }
}
