//
import Foundation

enum KeychainErrors: Error {
    case unableToSave
}

class KeychainManager: NSObject {
    static let shared = KeychainManager()

   @discardableResult
     public func saveKeychainKeyValue(str: String?, forKey: String, withBiometric: Bool = false) -> Bool {

       let dataFromString = str!.data(using: .utf8)
       let query: [String: Any]
       let searchquery: [String: Any]

       if str == nil {
           return false
       }

       if withBiometric {

           let access = SecAccessControlCreateWithFlags(nil, // Use the default allocator.
               kSecAttrAccessibleWhenPasscodeSetThisDeviceOnly,
               .userPresence,
               nil) // Ignore any error.

           query = [
               kSecClass as String: kSecClassGenericPassword as String,
               kSecAttrAccount as String: forKey,
               kSecAttrAccessControl as String: access as Any,
               kSecValueData as String: dataFromString!]

           searchquery = [
               kSecClass as String: kSecClassGenericPassword,
               kSecAttrAccount as String: forKey,
               kSecReturnData as String: kCFBooleanTrue,
               kSecMatchLimit as String: kSecMatchLimitOne]
       } else {

            query = [
               kSecClass as String: kSecClassGenericPassword as String,
               kSecAttrAccount as String: forKey,
               kSecValueData as String: dataFromString!]

           searchquery = [
               kSecClass as String: kSecClassGenericPassword,
               kSecAttrAccount as String: forKey,
               kSecReturnData as String: kCFBooleanTrue,
               kSecMatchLimit as String: kSecMatchLimitOne]
       }

       var status: OSStatus = SecItemAdd(query as CFDictionary, nil)

       if status == errSecDuplicateItem {
           updateKeychainKeyValue(str: str, forKey: forKey)
       }

       return status == noErr
   }

     func updateKeychainKeyValue(str: String?, forKey: String, withBiometric: Bool = false) {


       guard let valueData = str?.data(using: .utf8) else {
           //TODO
           return
       }

       let updateQuery: [String: Any] = [
           kSecClass as String: kSecClassGenericPassword,
           kSecAttrAccount as String: forKey
       ]

       let updateAttributes: [String: Any] = [
           kSecValueData as String: valueData
       ]


       if SecItemCopyMatching(updateQuery as CFDictionary, nil) == noErr {
           let status = SecItemUpdate(updateQuery as CFDictionary, updateAttributes as CFDictionary)
           if status != 0 {
               //TODO
           }
       }
   }

   func clearKeyChain() {
       let query: [String: Any] = [ kSecClass as String: kSecClassGenericPassword ]
       SecItemDelete(query as CFDictionary)
   }


   /**
    */

   internal func loadKeychainKey(key: String) -> String? {


       let query: [String: Any] = [
           kSecClass as String: kSecClassGenericPassword,
           kSecAttrAccount as String: key,
           kSecReturnData as String: kCFBooleanTrue,
           kSecMatchLimit as String: kSecMatchLimitOne
       ]

        var dataTypeRef: AnyObject?


       let status: OSStatus = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
       var contentsOfKeychain: String?

       if status == errSecSuccess {
           if let retrievedData = dataTypeRef as? Data {
               contentsOfKeychain = String(data: retrievedData, encoding: String.Encoding.utf8)
           }
       } else {
           //TODO
           print("Nothing was retrieved from the keychain. Status code \(status)")
       }

       return contentsOfKeychain
   }

   public func deleteData(key: String) throws {
       let queryDelete: [String: Any] = [
           kSecClass as String: kSecClassGenericPassword,
           kSecAttrAccount as String: key
       ]

       let resultCodeDelete = SecItemDelete(queryDelete as CFDictionary)

       if resultCodeDelete != errSecSuccess {
           //TODO
       }
   }

}
