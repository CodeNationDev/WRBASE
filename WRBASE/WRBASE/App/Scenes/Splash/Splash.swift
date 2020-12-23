//
import Foundation
import UIKit

class Splash: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        FirebaseManager.shared.delegate = self
        checkInitSteps()
        checkVersion()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
    }
    
    func checkInitSteps() {
        FirebaseManager.shared.retrieveAllCloudParameters()
    }
    
    func checkVersion() {
        if let version = FirebaseManager.shared.retrieveParameterValue(forKey: ParamKeys.RemoteConfig.Options.version_store.rawValue) {
            if !version.isEmpty {
                let result:ComparisonResult = version.compare(installedVersion(), options: .numeric)
                if result != .orderedSame {
                    LoggerManager.shared.log(message: "The AppStore version (\(version)) and installed version (\(installedVersion())) are different and app did closed.", level: .error, type: .system)
                }
            }
        } else {
            LoggerManager.shared.log(message: "[FIREBASE] An error occurred when retrieving the RemoteConfig values.", level: .error, type: .firebase)
        }
    }
    
    func installedVersion() -> String {
        let dictionary = Bundle.main.infoDictionary!
        let version = dictionary["CFBundleShortVersionString"] as! String
        let build = dictionary["CFBundleVersion"] as! String
        return "\(version).\(build)"
    }
}

extension Splash: FirebaseManagerDelegate {
    func parametersRetreived() {
        performSegue(withIdentifier: "main", sender: nil)
    }
}
