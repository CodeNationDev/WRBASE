//
import Foundation
import UIKit

class EnvironmentsViewController: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
    }
    
    func setupNavBar() {
        navigationItem.titleView = NavigationBarTitleView(title: "Cambio de entorno")
        navigationItem.leftItemsSupplementBackButton = false
        let leftAccessory = UIBarButtonItem(image: UIImage.backAccessory.withRenderingMode(.alwaysTemplate), style: .plain, target: self, action: #selector(leftButtonAction))
        leftAccessory.tintColor = .genericWhite
        navigationItem.setLeftBarButton(leftAccessory, animated: false)
    }
    
    @objc func leftButtonAction() {
        dismiss(animated: true, completion: nil)
    }
    
}
