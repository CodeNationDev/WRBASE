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
            case url_base_dev = "ios_wrbase_url"
            case url_base_pre = "ios_wrbase_url_pre"
            case version_store = "ios_wrbase_store_version"
        }
    }
}
