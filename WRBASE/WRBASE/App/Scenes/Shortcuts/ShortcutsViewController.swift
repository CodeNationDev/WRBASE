//
import Foundation
import UIKit

public protocol ShortcutsDelegate {
    func shortcutNavigationTo(url: URL)
}

class ShortcutsViewController: BaseViewController, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    var data = CoreDataManager.shared.loadShortcuts()
    public var delegate: ShortcutsDelegate?
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        setupTable()
        setupNavBar()
        
    }
    
    func setupTable() {
        tableView.register(TitleHeaderNImageCell.self, forCellReuseIdentifier: "cell")
        tableView.separatorColor = .clear
        tableView.isScrollEnabled = false
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 90
        tableView.backgroundColor = .genericWhite
        tableView.isEditing = true
        tableView.allowsSelectionDuringEditing = true
    }
    
    func setupNavBar() {
        navigationItem.titleView = NavigationBarTitleView(title: "Mis accesos directos")
        navigationItem.leftItemsSupplementBackButton = false
        let leftAccessory = UIBarButtonItem(image: UIImage.backAccessory.withRenderingMode(.alwaysTemplate), style: .plain, target: self, action: #selector(leftButtonAction))
        leftAccessory.tintColor = .genericWhite
        navigationItem.setLeftBarButton(leftAccessory, animated: false)
    }
    
    @objc func leftButtonAction() {
        dismiss(animated: true, completion: nil)
    }
    
}


extension ShortcutsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let delegate = delegate {
            delegate.shortcutNavigationTo(url: URL(string: data![indexPath.row].url!)!)
            dismiss(animated: true, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let data = data {
            return data.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TitleHeaderNImageCell
        if let data = data, let name = data[indexPath.row].name, let url = data[indexPath.row].url {
            cell.mainView.header.text = name
            cell.mainView.bodyMessage.text = url
            cell.separatorVisibility = false
        }
        cell.clipsToBounds = true
        cell.backgroundColor = .genericWhite
        cell.showsReorderControl = true
        cell.tintColor = .blueCaixa1
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if let _ = data {
            if editingStyle == .delete {
                CoreDataManager.shared.deleteShortcut(id: data![indexPath.row].id!) { (result, message) -> (Void) in
                    if result {
                        self.data!.remove(at: indexPath.row)
                        self.tableView.deleteRows(at: [indexPath], with: .fade)
                        self.updatePositions()
                        print(message)
                    } else {
                        print(message)
                    }
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        if let data = data {
            let movedObject = data[sourceIndexPath.row]
            self.data!.remove(at: sourceIndexPath.row)
            self.data!.insert(movedObject, at: destinationIndexPath.row)
            updatePositions()
        }
    }
    
    func updatePositions() {
        var i = 0
        if let _ = data {
            self.data!.indices.forEach {
                self.data![$0].position = i
                i += 1
            }
        }
        data!.forEach {
            CoreDataManager.shared.updateShortcut(id: $0.id!, position: $0.position!) { (result) -> (Void) in
                if result { print("SUCCESS UPDATING COREDATA") }
            }
        }
    }
}
