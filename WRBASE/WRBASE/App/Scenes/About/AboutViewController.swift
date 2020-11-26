//
import Foundation
import UIKit

class AboutViewController: BaseViewController, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
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
    }
    
    func setupNavBar() {
        navigationItem.titleView = NavigationBarTitleView(title: "Acerca de")
        navigationItem.leftItemsSupplementBackButton = false
        let leftAccessory = UIBarButtonItem(image: UIImage(named: "backAccessory")!.withRenderingMode(.alwaysTemplate), style: .plain, target: self, action: #selector(leftButtonAction))
        
        leftAccessory.tintColor = .genericWhite
        navigationItem.setLeftBarButton(leftAccessory, animated: false)

        //TODO: Remove this code, this page hasn't rightButtonItem ONLY FOR TEST.
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
    
    @objc func rightButtonAction() {
        performSegue(withIdentifier: "logs", sender: nil)
    }
    
    @objc func leftButtonAction() {
        self.dismiss(animated: true, completion: nil)
    }
}

extension AboutViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TitleHeaderNImageCell
        
        if indexPath.row == 0 {
            cell.mainView.header.text = "Mis Ventas"
            cell.mainView.bodyMessage.text = "Versión 1.0.6"
            cell.mainView.img = .ic_launcher
        }
        if indexPath.row == 1 {
            cell.mainView.header.text = "Detalles de la aplicación"
            cell.mainView.bodyMessage.text = "Aplicación de seguimiento de actividad comercial para empleados."
        }
        if indexPath.row == 2 {
            cell.mainView.header.text = "Detalles Tecnicos"
            cell.mainView.bodyMessage.text = "adam.ios.mca:MCAACE:1.20.1230 \nadam.ios.mca:MCAACE:1.20.1230 \nVersión de Firebase: 17.2.0 \nVersión de Crashlytics: 2.10.1"
        }
        
        return cell
    }
    
    
}
