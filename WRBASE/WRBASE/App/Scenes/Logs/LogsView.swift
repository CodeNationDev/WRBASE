//
import Foundation
import UIKit
import MessageUI

enum MailCases {
    case error, sent, cancelled, saved, unknown
}

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
        tableView.backgroundColor = .genericWhite
        tableView.allowsSelection = false
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
        mailComposer()
    }
    
    //Share with Activity
    func shareActivity() {
        let fileURL = LoggerManager.shared.prepareTextFile()!
        let activityView = UIActivityViewController(activityItems: [fileURL], applicationActivities: nil)
        activityView.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection()
        activityView.popoverPresentationController?.sourceRect = CGRect(x: 150, y: 150, width: 0, height: 0)
        self.present(activityView, animated: true, completion: nil)
    }
    
    func presentalert(mailCase: MailCases) -> UIViewController {
        var alert:UIAlertController?
        
        switch mailCase {
        case .sent: alert = UIAlertController(title: "Mensaje", message: "Mensaje enviado", preferredStyle: .alert)
            let accept = UIAlertAction(title: "Aceptar", style: .cancel, handler: nil)
            alert!.addAction(accept)
        case .cancelled: alert = UIAlertController(title: "Mensaje", message: "Mensaje cancelado", preferredStyle: .alert)
            let accept = UIAlertAction(title: "Aceptar", style: .cancel, handler: nil)
            alert!.addAction(accept)
        case .saved: alert = UIAlertController(title: "Mensaje", message: "Mensaje guardado", preferredStyle: .alert)
            let accept = UIAlertAction(title: "Aceptar", style: .cancel, handler: nil)
            alert!.addAction(accept)
        case .error: alert = UIAlertController(title: "Mensaje", message: "Error al enviar el mensaje", preferredStyle: .alert)
            let accept = UIAlertAction(title: "Aceptar", style: .cancel, handler: nil)
            alert!.addAction(accept)
        case .unknown: alert = UIAlertController(title: "Mensaje", message: "Estado desconocido", preferredStyle: .alert)
            let accept = UIAlertAction(title: "Aceptar", style: .cancel, handler: nil)
            alert!.addAction(accept)
        }
        
        return alert!
    }
}

//Share logs with MailComposer
extension LogsView: MFMailComposeViewControllerDelegate, UINavigationControllerDelegate {
    
    func mailComposer() {
        do {
            if MFMailComposeViewController.canSendMail() {
                let composer = MFMailComposeViewController()
                composer.mailComposeDelegate = self
                composer.setToRecipients(["bustia.mobilitat@caixabank.com"])
                composer.addAttachmentData(try Data(contentsOf: LoggerManager.shared.prepareTextFile()!), mimeType: "txt", fileName: "Logs")
                present(composer, animated: true)
            }
        } catch let error {
            LoggerManager.shared.log(message: error.localizedDescription)
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        switch result {
        case .cancelled: controller.dismiss(animated: true, completion: nil)
        case .failed: controller.present(presentalert(mailCase: .error), animated: true, completion: nil)
        case .saved: controller.dismiss(animated: true) {
            self.present(self.presentalert(mailCase: .saved), animated: true, completion: nil)
        }
        case .sent: controller.dismiss(animated: true) {
            self.present(self.presentalert(mailCase: .sent), animated: true, completion: nil)
        }
        @unknown default:
            controller.dismiss(animated: true) {
                self.present(self.presentalert(mailCase: .unknown), animated: true, completion: nil)
            }
        }
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
            cell.separatorVisibility = false
        }
        
        cell.clipsToBounds = true
        return cell
    }
}
