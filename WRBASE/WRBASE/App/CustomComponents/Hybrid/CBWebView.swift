//
import Foundation
import UIKit
import WebKit

public protocol CBKWKDelegate {
     func urlRequested(url: String)
     func downloadTask(forResult: Bool)
}
extension CBKWKDelegate {
    func urlRequested(url: String){}
    public func downloadTask(forResult: Bool){}
}



enum MimeType: String {
    case pdf = "application/pdf"
    case doc,docx = "application/msword"
    case xls, xlsx = "application/vnd.ms-excel"
    case ppt = "application/vnd.ms-powerpoint"
    case odt = "application/vnd.oasis.opendocument.text"
    case ods = "application/vnd.oasis.opendocument.spreadsheet"
    case odp = "application/vnd.oasis.opendocument.presentation"
    case rtf = "application/rtf"
    case jpg = "image/jpeg"
    case png = "image/png"
    case html = "text/html"
}


class CBWebView: WKWebView, WKNavigationDelegate, WKUIDelegate, UIDocumentInteractionControllerDelegate, CBKDocumentManagerDelegate {

    public var delegate: CBKWKDelegate?
    var documentViewer: UIDocumentInteractionController?
    var documentManager: CBKDocumentManager?
    var userController:WKUserContentController = WKUserContentController()
    
    public override init(frame: CGRect, configuration: WKWebViewConfiguration) {
        super.init(frame: frame, configuration: configuration)
        setupWK()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupWK()
    }
    
    func setupWK() {
        CBKDocumentManager.shared.documentViewerDelegate = self
        documentViewer = UIDocumentInteractionController()
        if let _ = documentViewer {
            self.documentViewer!.delegate = self
        }
        allowsBackForwardNavigationGestures = true
        addObserver(self, forKeyPath: "URL", options: .new, context: nil)
        addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
        configuration.userContentController.add(self, name: "callbackHandler")
        navigationDelegate = self
    }
    
    override public func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
        debugPrint("Loading...")
        
        if keyPath == #keyPath(WKWebView.estimatedProgress) {
            // When page load finishes. Should work on each page reload.
            if estimatedProgress == 1 {
                guard url != nil else {
                    return
                }
                debugPrint("### EP  \(url!.absoluteString)")
                LoggerManager.shared.log(message: "Navigating to: \(url!.absoluteString)")
                delegate?.urlRequested(url: url!.absoluteString)
            }
        }
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        if let mimeType = navigationResponse.response.mimeType {
            switch MimeType(rawValue: mimeType) {
            case .html: decisionHandler(.allow)
            default:
                CBKDocumentManager.shared.startDownload(url: navigationResponse.response.url)
                decisionHandler(.cancel)
            }
        }
    }
    
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        //Pending
    }
    public func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        //Pending
    }
    
    
    func didfinishDownloadWithError(_ response: String) {
        //Pending
    }
    
    func didFinishDownloadSuccess(_ url: URL) {
        documentViewer?.url = url
        DispatchQueue.main.async {
            self.documentViewer?.presentPreview(animated: true)
        }
    }
    
    public func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        UIApplication.getTopViewController()!
    }
    
}

extension CBWebView: WKScriptMessageHandler {
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        print(message.body)
    }
}



internal extension String {
    /**
     Method to check if string is valid URL.
     Returns boolean value.
     */
    func urlValidation() -> Bool {
        let urlRegEx = "((?:http|https)://)?(?:www\\.)?[\\w\\d\\-_]+\\.\\w{2,3}(\\.\\w{2})?(/(?<=/)(?:[\\w\\d\\-./_]+)?)?"
        return NSPredicate(format: "SELF MATCHES %@", urlRegEx).evaluate(with: self) || self.contains("http")
    }
}

