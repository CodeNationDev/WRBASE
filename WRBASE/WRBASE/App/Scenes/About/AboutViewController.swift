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
    }
    
    func setupNavBar() {
        navigationItem.titleView = NavigationBarTitleView(title: "Acerca de")
        navigationItem.leftItemsSupplementBackButton = false
        let leftAccessory = UIBarButtonItem(image: UIImage(named: "backAccessory")!.withRenderingMode(.alwaysTemplate), style: .plain, target: self, action: #selector(leftButton))
        leftAccessory.tintColor = .genericWhite
        navigationItem.setLeftBarButton(leftAccessory, animated: false)
    }
    
    @objc func leftButton() {
        self.dismiss(animated: true, completion: nil)
    }
}

extension AboutViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        3
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 90
        }
        if indexPath.row == 1 {
            return 110
        }
        return 180     
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
        
        let seperatorImageView = UIView(frame: .zero)
        seperatorImageView.backgroundColor = .grayCaixa1
        seperatorImageView.frame = CGRect(x: 0, y: cell.contentView.frame.size.height - 1.0,  width: cell.contentView.frame.size.width, height: 1.5)
        cell.contentView.addSubview(seperatorImageView)
        
        return cell
    }
    
    
}
