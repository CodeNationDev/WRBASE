//
import Foundation
import UIKit


class AboutViewController: BaseViewController, UITableViewDelegate {
    
    enum AboutOptions: Int {
        case logs = 0
        case environment = 1
    }
    
    var pickerPresented = false
    let picker = CBKPickerView(items: [(ParamKeys.Environment.Options.pre.rawValue, 0),(ParamKeys.Environment.Options.pro.rawValue, 1)])
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        setupTable()
        setupNavBar()
        shakeAction = {
            self.launchContextualMenu()
        }
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissPicker))
        tableView.addGestureRecognizer(tapGestureRecognizer)
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
    }
    
    @objc func rightButtonAction() {
        performSegue(withIdentifier: "logs", sender: nil)
    }
    
    @objc func leftButtonAction() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func launchContextualMenu() {
        let vc = CBKContextualMenuViewController(menuTitle: "Options", options: [
            CBKContextualMenuOption(withIcon: "bookmarks", andTitle: "Ver Logs"),
            CBKContextualMenuOption(withIcon: "about", andTitle: "Cambiar de entorno"),
        ],
        delegate: self)
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        present(vc, animated: true, completion: nil)
    }
    
    @objc func dismissPicker(sender: UISwipeGestureRecognizer) {
        if(pickerPresented) {
            UIView.transition(with: self.view, duration: 0.25, options: [.transitionCrossDissolve], animations: {
                self.picker.removeFromSuperview()
                self.pickerPresented = false
            }, completion: nil)
        }
    }
}


extension AboutViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        4
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
        if indexPath.row == 3 {
            cell.mainView.header.text = "Entorno"
            if let results = CoreDataManager.shared.loadParameter(forKey: ParamKeys.Environment.key), results.first != nil, let value = results.first!.value {
                cell.mainView.bodyMessage.text = value
            } else {
                cell.mainView.bodyMessage.text = "Unknown"
            }
            
        }
        cell.layoutIfNeeded()
        
        return cell
    }
}

extension AboutViewController: CBKContextualMenuViewControllerDelegate, CBKPickerViewDelegate {
    func didSelectOption(item: (String, Int)) {
        switch ParamKeys.Environment.Options(rawValue: item.0) {
        case .pre: updateEnvironment(env: .pre)
        case .pro: updateEnvironment(env: .pro)
        case .none:
            LoggerManager.shared.log(message: "Unknown environment selected")
        }
    }
    
    func updateEnvironment(env: ParamKeys.Environment.Options) {
        if let result = CoreDataManager.shared.loadParameter(forKey: ParamKeys.Environment.key) {
            if !result.isEmpty {
                CoreDataManager.shared.updateParameter(forKey: ParamKeys.Environment.key, value: env.rawValue) { (result) in
                    if result {
                        UIView.performWithoutAnimation {
                            self.tableView.beginUpdates()
                            self.tableView.reloadData()
                            self.tableView.endUpdates()
                        }
                    }
                }
            } else {
                CoreDataManager.shared.saveParameter(forKey: ParamKeys.Environment.key, value: env.rawValue) { (result) -> (Void) in
                    if result {
                        UIView.performWithoutAnimation {
                            self.tableView.beginUpdates()
                            self.tableView.reloadData()
                            self.tableView.endUpdates()
                        }
                    }
                }
            }
        }
    }
    
    func pressed(option: Int) {
        switch AboutOptions(rawValue: option) {
        case .logs: performSegue(withIdentifier: "logs", sender: nil)
        case .environment:
            picker.cbkDelegate = self
            picker.translatesAutoresizingMaskIntoConstraints = false
            UIView.transition(with: self.view, duration: 0.25, options: [.transitionCrossDissolve], animations: {
                self.view.addSubview(self.picker)
                self.pickerPresented = true
            }, completion: nil)
            NSLayoutConstraint.activate([
                picker.widthAnchor.constraint(equalToConstant: view.frame.width),
                picker.heightAnchor.constraint(equalToConstant: 300),
                picker.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
                picker.centerXAnchor.constraint(equalTo: view.centerXAnchor)
            ])
            view.bringSubviewToFront(picker)
            view.sendSubviewToBack(tableView)
            
            if let results = CoreDataManager.shared.loadParameter(forKey: ParamKeys.Environment.key), results.first != nil, let value = results.first!.value {
                switch ParamKeys.Environment.Options(rawValue: value) {
                case .pre: self.picker.selectRow(0, inComponent: 0, animated: true)
                case .pro: self.picker.selectRow(1, inComponent: 0, animated: true)
                case .none: break
                }
            }
            
        case .none:
            print("None selection option pressed")
        }
    }
}
