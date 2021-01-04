//
import Foundation

struct ParamKeys {
    public struct Environment {
        public static var key = "environment"
        public enum Options: String {
            case pre = "PRE"
            case pro = "PRO"
        }
    }
    public struct RemoteConfig {
        public enum Options: String {
            case url_base = "ios_wrbase_url"
            case version_store = "ios_wrbase_store_version"
            
            var storedValue: String? {
                switch self {
                case .url_base: return CoreDataManager.shared.loadParameter(forKey: Options.url_base.rawValue)?.first?.value
                case .version_store: return CoreDataManager.shared.loadParameter(forKey: Options.version_store.rawValue)?.first?.value
                }
            }
        }
    }
    public struct NetworkReachability {
        public enum Options: String {
            case notReachable, reachableOnCellular, reachableOnWifi
        }
    }
    public struct Autologin {
        static var key = "autologin"
        static var loginPageFlag = "qlspro.lacaixa.es/internal_forms_authentication"
    }
}
