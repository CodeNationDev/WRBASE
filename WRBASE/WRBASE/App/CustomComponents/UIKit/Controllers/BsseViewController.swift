//
import Foundation
import UIKit

class BaseViewController: UIViewController {
    
    public let statusbar: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .blueCaixa1
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    func setupView() {
        view.addSubview(statusbar)
        NSLayoutConstraint.activate([
            statusbar.widthAnchor.constraint(equalToConstant: view.frame.width),
            statusbar.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            statusbar.topAnchor.constraint(equalTo: view.topAnchor),
            statusbar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        ])
    }
    
}
