//
import Foundation
import UIKit

class Splash: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkInitSteps()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        performSegue(withIdentifier: "main", sender: nil)
    }
    
    func checkInitSteps() {
        FirebaseManager.shared.retrieveAllCloudParameters()
    }
}
