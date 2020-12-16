//
import Foundation
import Firebase


public class FirebaseManager {
    public static let shared = FirebaseManager()
    let remoteConfig = RemoteConfig.remoteConfig()
    let settings = RemoteConfigSettings()
    
    private init() {
        settings.minimumFetchInterval = 0
        remoteConfig.configSettings = settings
        checkRemoteConfig(completionHandler: nil)
    }
    
    public func track_event(name: String, parameters: [String : Any]?) {
        Firebase.Analytics.logEvent(name, parameters: parameters)
    }
    
    public func checkRemoteConfig(completionHandler: (()->(Void))?) {
        remoteConfig.fetch() { status, error in
            if let error = error {
                LoggerManager.shared.log(message: "[FIREBASE] Got an error fetching remote values \(error)")
                return
            }
            RemoteConfig.remoteConfig().activate(completion: nil)
            LoggerManager.shared.log(message: "[FIREBASE] Retrieved values from the cloud!")
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
                LoggerManager.shared.log(message: "RemoteConfig value \($0):\(value) saved")
                print( "RemoteConfig value \($0):\(value) saved")
            }
        }
    }
}
