//
import UIKit

public class ReplaceSegue: UIStoryboardSegue {
    
    public override func perform() {
         if let shredDelegate = UIApplication.shared.delegate, let rWindow = shredDelegate.window, let inWindow = rWindow {
             UIView.transition(with: inWindow, duration: 0.5, options: .transitionFlipFromBottom, animations: {
                 if let delegate = UIApplication.shared.delegate as? AppDelegate, let rootwindow = delegate.window {
                     rootwindow.rootViewController = self.destination
                 }
             }, completion: nil)
         }
     }
}

