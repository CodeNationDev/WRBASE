//
import Foundation
import UIKit

enum Destinations: Int {
    case shortcuts = 0
    case about = 1
}

class MainView: BaseViewController, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var webView: CBNavigator!
    public let initialURL: String? = "https://www.google.es"
    
    
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
            let vc = ShortcutSavaBoxViewController(nibName: "ShortcutSavaBoxViewController", bundle: .main)
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .overFullScreen
            vc.imageIcon = .favorites
            vc.titleLabelText = "Add new shortcut"
            vc.bodyLabelText = webView.url
            vc.buttonTitle = "Ok"
            vc.actionTarget = {
                CoreDataManager.shared.saveShortcut(name: vc.shortcutName, url: self.webView.urlRequested) { (result) -> (Void) in
                    if result {
                        print("SUCCESSSSSS!!!!")
                        vc.bodyLabel.text = "Success, shortcut saved"
                        vc.txShortcutName.isEnabled = false
                    }
                }
            }
            present(vc, animated: true, completion: nil)
        }
    }
    
    /// Prepare segue override for pass parameters to next ViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier, identifier.elementsEqual("shortcuts") {
            if let navigation = segue.destination as? CBKNavigationController {
                if let mainVc = navigation.viewControllers.first as? ShortcutsViewController {
                    mainVc.delegate = self
                }
            }
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

extension MainView: ShortcutsDelegate {
    func shortcutNavigationTo(url: URL) {
        webView.url = url.absoluteString
    }
}
