//
import Alamofire
import Foundation

public class NetworkActivityObserver {
    let manager = Alamofire.NetworkReachabilityManager(host: "www.google.com")
    let nc = NotificationCenter.default

    public init() {
        start()
    }
    
    func start() {
        manager?.startListening(onUpdatePerforming: { (status) in
            switch status {
            case .notReachable: self.nc.post(name: Notification.Name.networkReachability, object: ParamKeys.NetworkReachability.Options.notReachable)
            case .reachable(.cellular): self.nc.post(name: Notification.Name.networkReachability, object: ParamKeys.NetworkReachability.Options.reachableOnCellular)
            case .reachable(.ethernetOrWiFi): self.nc.post(name: Notification.Name.networkReachability, object: ParamKeys.NetworkReachability.Options.reachableOnWifi)
            case .unknown: break
            }
        })
    }
}
