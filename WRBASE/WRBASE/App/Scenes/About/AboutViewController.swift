//
import Foundation
import UIKit


class AboutViewController: BaseViewController, UITableViewDelegate {
    
    enum AboutOptions: Int {
        case logs = 0
        case environment = 1
    }
    
    var pickerPresented = false
    var appVersion: String = "1.0.6"
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewID = "AboutView"
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
        navigationItem.titleView = NavigationBarTitleView(title: NSLocalizedString("about_nav_title", comment: ""))
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
        let vc = CBKContextualMenuViewController(menuTitle: NSLocalizedString("context_menu_title", comment: ""), options: [
            CBKContextualMenuOption(withIcon: "bookmarks", andTitle: NSLocalizedString("logs_title", comment: "")),
            CBKContextualMenuOption(withIcon: "about", andTitle: NSLocalizedString("change_env_title", comment: "")),
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
            cell.mainView.header.text = NSLocalizedString("app_title", comment: "")
            cell.mainView.bodyMessage.text = String(format: NSLocalizedString("app_version", comment: ""), appVersion)
            cell.mainView.img = .ic_launcher
        }
        if indexPath.row == 1 {
            cell.mainView.header.text = NSLocalizedString("app_details_title", comment: "")
            cell.mainView.bodyMessage.text = NSLocalizedString("app_details_info", comment: "")
        }
        if indexPath.row == 2 {
            cell.mainView.header.text = NSLocalizedString("app_technical_details_title", comment: "")
            cell.mainView.bodyMessage.text = NSLocalizedString("app_technical_details_info", comment: "")
        }
        if indexPath.row == 3 {
            cell.mainView.header.text = NSLocalizedString("app_env_title", comment: "")
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
