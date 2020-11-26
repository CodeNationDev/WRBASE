//
import Foundation
import CoreData
import UIKit

public struct LogItem {
    var date: String?
    var message: String?
}

public class LoggerManager: NSObject {
    public static let shared = LoggerManager()
    let filename = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("log.txt")
    var fileHandle: FileHandle?
    var context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    
    public func log(message: String) {
        let entity = NSEntityDescription.entity(forEntityName: "Log", in: context!)!
        let log = NSManagedObject(entity: entity, insertInto: context!)
        log.setValue(message, forKey: "message")
        log.setValue(dateNow(), forKey: "date")
        do {
            try context?.save()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    public func loadLogs(last: Int? = 1000) -> [LogItem]? {
        var items:[LogItem] = []
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Log")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        fetchRequest.fetchLimit = last!
        do {
            let log = try context!.fetch(fetchRequest)
            log.forEach {
                if let date = $0.value(forKey: "date") as? String, let message = $0.value(forKey: "message") as? String {
                    print("\(date) - \(message)")
                    items.append(LogItem(date: date, message: message))
                }
               
            }
            return items
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        return nil
    }
    
    public func prepareTextFile() -> URL? {
        var str = ""
        if let logs = loadLogs() {
            var array: [String] = []
            logs.forEach{ array.append("\($0.date!) - \($0.message!)")}
            str = array.joined(separator: "\n")
        }

        if let filename = filename {
            do {
                try str.write(to: filename, atomically: true, encoding: .utf8)
                return filename
            } catch let error {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    
    deinit {
        fileHandle?.closeFile()
    }
    
    public func loadLast(number of: Int? = 1000) {
        do {
            if let filename = filename {
                if FileManager.default.fileExists(atPath: filename.path) {
                    let data = try String(contentsOfFile: filename.path)
                    var logs = data.components(separatedBy: .newlines)
                    logs = logs.suffix(of!)
                    print(logs)
                }
            }
        } catch let error {
            print("Unable to write logs in file due to: \(error.localizedDescription)")
        }
    }
    
    private func dateNow() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy HH:mm:ss"
        let date = Date()
        return formatter.string(from: date)
    }
    
    private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
