//
import Foundation
import UIKit

class MainView: BaseViewController, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var webView: CBNavigator!
    public let initialURL: String? = "https://www.google.es"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        webView.url = initialURL!
        shakeAction = {
            self.performSegue(withIdentifier: "about", sender: nil)
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
