//
import Foundation
import Firebase

public protocol FirebaseManagerDelegate {
    func parametersRetreived()
}

public class FirebaseManager {
    public static let shared = FirebaseManager()
    public var delegate: FirebaseManagerDelegate? {
        didSet {
            checkRemoteConfig(completionHandler: nil)
        }
    }
    let remoteConfig = RemoteConfig.remoteConfig()
    let settings = RemoteConfigSettings()
    
    private init() {
        settings.minimumFetchInterval = 0
        remoteConfig.configSettings = settings
    }
    
    public func track_event(name: String, parameters: [String : Any]?) {
        Firebase.Analytics.logEvent(name, parameters: parameters)
    }
    
    public func checkRemoteConfig(completionHandler: (()->(Void))?) {
        remoteConfig.fetch() { status, error in
            if let error = error {
                LoggerManager.shared.log(message: "Got an error fetching RemoteConfig values \(error)", level: .error, type: .firebase)
                return
            }
            RemoteConfig.remoteConfig().activate(completion: nil)
            self.delegate?.parametersRetreived()
            LoggerManager.shared.log(message: "Retrieved RemoteConfig values from the cloud!", level: .success, type: .firebase)
        }
    }
    
    public func retrieveParameterValue(forKey: String) -> String? {
        remoteConfig.configValue(forKey: forKey).stringValue
    }
    
    public func retrieveAllCloudParameters() {
        remoteConfig.allKeys(from: RemoteConfigSource.remote).filter { (flag) -> Bool in
            return flag.contains("ios_")
        }.forEach {
            if let value = retrieveParameterValue(forKey: $0) {
                if let _ = CoreDataManager.shared.loadParameter(forKey: $0) {
                    CoreDataManager.shared.removeParameter(forKey: $0)
                }
                CoreDataManager.shared.saveParameter(forKey: $0, value: value, completionHandler: nil)
                LoggerManager.shared.log(message: "RemoteConfig value \($0):\(value) saved", level: .success, type: .coredata)
            }
        }
    }
}
