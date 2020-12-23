//
import UIKit
import CoreData
import Firebase

enum QuickActions: String {
    case about = "com.app.shortcut.about"
    case shortcuts = "com.app.shortcut.shortcuts"
}

public struct Singletons {
    static var networkReachability: NetworkActivityObserver?
}

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
    var shortcutItemToProcess: UIApplicationShortcutItem?
    var networkReachability: NetworkActivityObserver?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        networkReachability = NetworkActivityObserver()
        Singletons.networkReachability = networkReachability
        
        FirebaseApp.configure()
        let _ = FirebaseManager.shared
        
        if let shortcutItem = launchOptions?[UIApplication.LaunchOptionsKey.shortcutItem] as? UIApplicationShortcutItem {
            shortcutItemToProcess = shortcutItem
        }
        
        return true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        
        if let shortcutItem = shortcutItemToProcess {
            switch QuickActions(rawValue: shortcutItem.type) {
            case .about: router(name: "About")
            case .shortcuts: router(name: "Shortcuts")
            case .none: break
            }
        }
        shortcutItemToProcess = nil
    }
    
    func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        shortcutItemToProcess = shortcutItem
    }
    
    func router(name: String) {
        let navigationController = UIStoryboard(name: name, bundle: .main).instantiateInitialViewController()
        if let nc = navigationController as? CBKNavigationController {
            nc.modalPresentationStyle = .fullScreen
            if let _ = nc.viewControllers.first as? ShortcutsViewController {
                (nc.viewControllers.first as! ShortcutsViewController).delegate = window?.rootViewController as? ShortcutsDelegate
            }
            window!.rootViewController?.present(nc, animated: true, completion: nil)
        }
    }

    
    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "WRBASE")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                LoggerManager.shared.log(message: "Unresolved error \(error), \(error.userInfo)", level: .error, type: .coredata)
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                LoggerManager.shared.log(message: "Unresolved error saving in context \(nserror), \(nserror.userInfo)", level: .error, type: .coredata)
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

