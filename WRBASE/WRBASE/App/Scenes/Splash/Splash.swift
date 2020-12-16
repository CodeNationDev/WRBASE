//
import Foundation
import UIKit

class Splash: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkInitSteps()
        checkVersion()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        performSegue(withIdentifier: "main", sender: nil)
    }
    
    func checkInitSteps() {
        FirebaseManager.shared.retrieveAllCloudParameters()
    }
    
    func checkVersion() {
        if let version = FirebaseManager.shared.retrieveParameterValue(forKey: ParamKeys.RemoteConfig.Options.version_store.rawValue) {
            let result:ComparisonResult = version.compare(installedVersion(), options: .numeric)
            if result != .orderedSame {
                LoggerManager.shared.log(message: "The AppStore version (\(version)) and installed version (\(installedVersion())) are different and app did closed.")
                exit(0)
            }
        }
    }
    
    func installedVersion() -> String {
        let dictionary = Bundle.main.infoDictionary!
        let version = dictionary["CFBundleShortVersionString"] as! String
        let build = dictionary["CFBundleVersion"] as! String
        return "\(version).\(build)"
    }
}
