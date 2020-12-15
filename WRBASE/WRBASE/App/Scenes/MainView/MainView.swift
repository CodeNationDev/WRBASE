//
import Foundation
import UIKit

enum Destinations: Int {
    case shortcuts = 0
    case about = 1
}

class MainView: BaseViewController, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var webView: CBNavigator!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        //        if let url = CoreDataManager.shared.loadParameter(forKey: "wrbase_url")?.first?.value {
        //            webView.url = url
        //        }
        let localURL = Bundle.main.url(forResource: "sampleloginweb", withExtension: "html")
        webView.url = localURL!.absoluteString
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewID = "MainView"
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    @objc func navigate(url: String) {
        webView.url = url
    }
    
    @objc func nameLongPressed(sender: UISwipeGestureRecognizer) {
        if sender.state == .began {
            let vc = ShortcutSavaBoxViewController()
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .overCurrentContext
            present(vc, animated: true, completion: nil)
            vc.imageIcon = .favorites
            vc.titleLabelText = NSLocalizedString("add_shortcut", comment: "")
            vc.bodyLabelText = webView.url
            vc.button1Title = NSLocalizedString("accept_literal", comment: "")
            vc.actionButton1Target = {
                CoreDataManager.shared.saveShortcut(name: vc.shortcutName, url: self.webView.urlRequested) { (result) -> (Void) in
                    if result {
                        LoggerManager.shared.log(message: "Shortcut added \(self.webView.url) ")
                        
                        vc.bodyLabelText = NSLocalizedString("save_shortcut_succeed", comment: "")
                        vc.txShortcutName.isEnabled = false
                        vc.button1.isHidden = true
                        vc.button2Title = NSLocalizedString("close_literal", comment: "")
                    }
                }
            }
            vc.button2Title = NSLocalizedString("cancel_literal", comment: "")
            vc.actionButton2Target = {
                vc.dismiss(animated: true, completion: nil)
            }
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
        let vc = CBKContextualMenuViewController(menuTitle: NSLocalizedString("context_menu_title", comment: ""), options: [
            CBKContextualMenuOption(withIcon: "bookmarks", andTitle: NSLocalizedString("shortcuts_title", comment: "")),
            CBKContextualMenuOption(withIcon: "about", andTitle: NSLocalizedString("about_title", comment: "")),
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
