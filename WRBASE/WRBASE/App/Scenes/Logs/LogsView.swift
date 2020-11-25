//
import Foundation
import UIKit

class LogsView: BaseViewController, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    let data = LoggerManager.shared.loadLogs()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        setupNavBar()
        setupTable()
    }
    
    func setupTable() {
        tableView.register(TitleHeaderNImageCell.self, forCellReuseIdentifier: "cell")
        tableView.separatorColor = .clear
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44
    }
    
    func setupNavBar() {
        navigationItem.titleView = NavigationBarTitleView(title: "Ver logs")
        navigationItem.leftItemsSupplementBackButton = false
        let leftAccessory = UIBarButtonItem(image: UIImage.backAccessory.withRenderingMode(.alwaysTemplate), style: .plain, target: self, action: #selector(leftButtonAction))
        leftAccessory.tintColor = .genericWhite
        navigationItem.setLeftBarButton(leftAccessory, animated: false)
        
        let button = UIButton(type: .system)
        let buttonImage = UIImage.message.withRenderingMode(.alwaysTemplate)
        button.setImage(buttonImage, for: .normal)
        button.addTarget(self, action: #selector(rightButtonAction), for: .touchUpInside)
        button.tintColor = .genericWhite

        let menuBarItem = UIBarButtonItem(customView: button)
        menuBarItem.customView?.translatesAutoresizingMaskIntoConstraints = false
        menuBarItem.customView?.heightAnchor.constraint(equalToConstant: 30).isActive = true
        menuBarItem.customView?.widthAnchor.constraint(equalToConstant: 30).isActive = true
        
        navigationItem.rightBarButtonItem = menuBarItem
    }
    
    @objc func leftButtonAction() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func rightButtonAction() {
        print("RIGT BUTTON!!!!....")
    }

}

extension LogsView: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let data = data {
            return data.count
        }
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TitleHeaderNImageCell
        
        if let data = data {
            cell.mainView.header.text = data[indexPath.row].date!
            cell.mainView.bodyMessage.text = data[indexPath.row].message!
        }
        
        cell.clipsToBounds = true
        return cell
    }
    
    
}
