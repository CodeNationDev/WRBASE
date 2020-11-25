//
import Foundation
import UIKit

public class CBKNavigationController: UINavigationController {
    
    public override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    // MARK: - Override
    public override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    // MARK: - Custom
    private func setup() {
        navigationBar.barTintColor = .blueCaixa1
        navigationBar.isOpaque = true
        navigationBar.titleTextAttributes = [.foregroundColor: UIColor.genericWhite, .backgroundColor: UIColor.blueCaixa1 , .font: UIFont.openSansRegular(size: 18)]
        
    }
}
