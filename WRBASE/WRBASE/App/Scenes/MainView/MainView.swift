//
import Foundation
import UIKit

enum Destinations: Int {
    case shortcuts = 0
    case about = 1
}

class MainView: BaseViewController, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var webView: CBNavigator!
    public let initialURL: String? = "https://www.qlik.com/us/"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        webView.url = initialURL!
        shakeAction = {
            self.launchContextualMenu()
        }
    
        let nameLongPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(nameLongPressed))
        nameLongPressRecognizer.minimumPressDuration = 0.5
        nameLongPressRecognizer.delaysTouchesBegan = true
        nameLongPressRecognizer.delegate = self
        webView.isUserInteractionEnabled = true
        webView.addGestureRecognizer(nameLongPressRecognizer)
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
      return true
    }
    
    @objc func nameLongPressed(sender: UISwipeGestureRecognizer) {
        if sender.state == .began {
            print("LONG PRESS DETECTED!!!")
        }
    }
}

extension MainView: CBKContextualMenuViewControllerDelegate {
    func pressed(option: Int) {
        switch Destinations(rawValue: option) {
        case .about: self.performSegue(withIdentifier: "about", sender: nil)
        case .shortcuts: self.performSegue(withIdentifier: "shortcuts", sender: nil)
        case .none:
            print("NONE")
        }
    }
    
    
    func launchContextualMenu() {
        let vc = CBKContextualMenuViewController(menuTitle: "Options", options: [
                                                    CBKContextualMenuOption(withIcon: "bookmarks", andTitle: "Favoritos"),
                                                    CBKContextualMenuOption(withIcon: "about", andTitle: "Acerca de..."),
                                                    ],
        delegate: self)
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        present(vc, animated: true, completion: nil)
    }
    
}
