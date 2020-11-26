//
import Foundation
import UIKit
import CoreData

public struct ShortcutItem {
    var name: String?
    var url: String?
    var id: UUID?
}

public class ShortcutManager: NSObject {
    public static let shared = ShortcutManager()
    var context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    
    public func saveShortcut(name: String, url: String) {
        let entity = NSEntityDescription.entity(forEntityName: "Shortcut", in: context!)!
        let log = NSManagedObject(entity: entity, insertInto: context!)
        log.setValue(name, forKey: "name")
        log.setValue(url, forKey: "url")
        log.setValue(UUID().uuid, forKey: "id")
        do {
            try context?.save()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    public func loadShortcuts() -> [ShortcutItem]? {
        var items:[ShortcutItem] = []
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Shortcuts")
        do {
            let log = try context!.fetch(fetchRequest)
            log.forEach {
                if let name = $0.value(forKey: "name") as? String, let url = $0.value(forKey: "url") as? String, let id = $0.value(forKey: "id") as? UUID  {
                    items.append(ShortcutItem(name: name, url: url, id: id))
                }
            }
            return items
        } catch let error as NSError {
            print("[ERROR] Could not fetch. \(error), \(error.userInfo)")
        }
        return nil
    }
    
    public func updateShortcut(id: UUID, name: String?, url: String?) {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Shortcuts")
        let predicate = NSPredicate(format: "id == %@", "\(id)")
        fetchRequest.predicate = predicate
        do {
            let result = try context!.fetch(fetchRequest)
            if let item = result.first {
                if let name = name {
                    item.setValue(name, forKey: "name")
                }
                if let url = url {
                    item.setValue(url, forKey: "url")
                }
            }
            
        } catch let error {
            LoggerManager.shared.log(message: "[ERROR] Updating shortcut: \(error.localizedDescription)")
        }
    }
    
    
}

