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
}
