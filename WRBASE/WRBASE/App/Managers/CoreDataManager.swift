//
import Foundation
import UIKit
import CoreData

public struct ShortcutItem {
    var name: String?
    var url: String?
    var id: UUID?
    var position: Int?
}

public struct ParameterItem {
    var key: String?
    var value: String?
}

public class CoreDataManager: NSObject {
    public static let shared = CoreDataManager()
    var context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    
    public func saveShortcut(name: String, url: String, completionHandler: @escaping (Bool)->(Void)) {
        DispatchQueue.main.async {
            let entity = NSEntityDescription.entity(forEntityName: "Shortcut", in: self.context!)!
            let shortcut = NSManagedObject(entity: entity, insertInto: self.context!)
            shortcut.setValue(name, forKey: "name")
            shortcut.setValue(url, forKey: "url")
            shortcut.setValue(self.followSequence(), forKey: "position")
            shortcut.setValue(UUID(), forKey: "id")
            do {
                try self.context?.save()
                completionHandler(true)
            } catch let error {
                print(error.localizedDescription)
            }
        }
    }
    
    public func loadShortcuts() -> [ShortcutItem]? {
        var items:[ShortcutItem] = []
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Shortcut")
        let sort = NSSortDescriptor(key: "position", ascending: true)
        fetchRequest.sortDescriptors = [sort]
        do {
            let log = try context!.fetch(fetchRequest)
            log.forEach {
                if let name = $0.value(forKey: "name") as? String, let url = $0.value(forKey: "url") as? String, let id = $0.value(forKey: "id") as? UUID, let position = $0.value(forKey: "position") as? Int  {
                    items.append(ShortcutItem(name: name, url: url, id: id, position: position))
                }
            }
            return items
        } catch let error as NSError {
            LoggerManager.shared.log(message: "[ERROR] Could not fetch. \(error), \(error.userInfo)", level: .error, type: .coredata)
        }
        return nil
    }
    
    public func updateShortcut(id: UUID, name: String? = nil, url: String? = nil, position: Int? = nil, completionHandler: @escaping (Bool)->(Void)) {
        DispatchQueue.main.async {
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Shortcut")
            let predicate = NSPredicate(format: "id == %@", "\(id)")
            fetchRequest.predicate = predicate
            do {
                let result = try self.context!.fetch(fetchRequest)
                if let item = result.first {
                    if let name = name {
                        item.setValue(name, forKey: "name")
                    }
                    if let url = url {
                        item.setValue(url, forKey: "url")
                    }
                    if let position = position {
                        item.setValue(position, forKey: "position")
                    }
                    try self.context?.save()
                    completionHandler(true)
                }
                
            } catch let error {
                LoggerManager.shared.log(message: "Updating shortcut: \(error.localizedDescription)", level: .error, type: .coredata)
            }
        }
    }
    
    public func deleteShortcut(id: UUID, name: String? = nil, url: String? = nil, position: Int? = nil, completionHandler: @escaping (Bool, String)->(Void)) {
        DispatchQueue.main.async {
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Shortcut")
            let predicate = NSPredicate(format: "id == %@", "\(id)")
            fetchRequest.predicate = predicate
            do {
                let result = try self.context!.fetch(fetchRequest)
                if let context = self.context, let first = result.first {
                    context.delete(first)
                    try context.save()
                    completionHandler(true, "Deletion success")
                } else { completionHandler(false, "Deletion failed") }
                
            } catch let error {
                LoggerManager.shared.log(message: "[ERROR] Updating shortcut: \(error.localizedDescription)", level: .error, type: .coredata)
            }
        }
    }
    
    public func followSequence() -> Int? {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Shortcut")
        let sortDescriptor = NSSortDescriptor(key: "position", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        do {
            let max = try context!.fetch(fetchRequest)
            return max.count
            
        } catch let error as NSError {
            LoggerManager.shared.log(message: "[ERROR] Could not fetch. \(error), \(error.userInfo)", level: .error, type: .coredata)
        }
        return nil
    }
    
    public func saveParameter(forKey: String, value: String, completionHandler: ((Bool)->(Void))? = nil) {
        DispatchQueue.main.async {
            let entity = NSEntityDescription.entity(forEntityName: "GenericParams", in: self.context!)!
            let shortcut = NSManagedObject(entity: entity, insertInto: self.context!)
            shortcut.setValue(forKey, forKey: "key")
            shortcut.setValue(value, forKey: "value")
            
            do {
                try self.context?.save()
                if let completion = completionHandler { completion(true) }
            } catch let error {
                print(error.localizedDescription)
            }
        }
    }
    
    public func loadParameter(forKey: String? = nil) -> [ParameterItem]? {
        var items:[ParameterItem] = []
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "GenericParams")
        if let forkey = forKey {
            let predicate = NSPredicate(format: "key == %@", "\(forkey)")
            fetchRequest.predicate = predicate
        }
        do {
            let log = try context!.fetch(fetchRequest)
            log.forEach {
                if let key = $0.value(forKey: "key") as? String, let value = $0.value(forKey: "value") as? String  {
                    items.append(ParameterItem(key: key, value: value))
                }
            }
            return items
        } catch let error as NSError {
            LoggerManager.shared.log(message: "[ERROR] Could not fetch. \(error), \(error.userInfo)", level: .error, type: .coredata)
        }
        return nil
    }
    
    public func removeParameter(forKey: String, completionHandler: ((Bool)->(Void))? = nil) {
        DispatchQueue.main.async {
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "GenericParams")
            let predicate = NSPredicate(format: "key == %@", "\(forKey)")
            fetchRequest.predicate = predicate
            do {
                let result = try self.context!.fetch(fetchRequest)
                if let context = self.context, let first = result.first {
                    context.delete(first)
                    try context.save()
                    if let completion = completionHandler {
                        completion(true)
                    }
                } else {
                    if let completion = completionHandler {
                        completion(false)
                    }
                }
                
            } catch let error {
                LoggerManager.shared.log(message: "Updating parameter: \(error.localizedDescription)", level: .error, type: .coredata)
            }
        }
    }
    
    public func updateParameter(forKey: String, value: String, completionHandler: ((Bool)->())? = nil) {
        DispatchQueue.main.async {
            self.removeParameter(forKey: forKey) { (success) -> () in
                if success {
                    self.saveParameter(forKey: forKey, value: value) { (success) -> (Void) in
                        if success {
                            if let completion = completionHandler {
                                completion(true)
                            }
                        } else
                        if let completion = completionHandler {
                            completion(false)
                        }
                    }
                }
            }
        }
    }
    
}

