//
import Foundation
import UIKit
import WebKit

public class CBNavigator: UIView {
    
    public var url: String = "about:blank" {
        didSet {
            webView.load(URLRequest(url: URL(string: url)!))
        }
    }
    
    
    
    
    public var urlRequested: String = ""
    
    var webView: CBWebView = {
        let contentController = WKUserContentController()
        let scrpt = JSManager.shared.prepareInjection()
        contentController.addUserScript(scrpt)
        let config = WKWebViewConfiguration()
        config.userContentController = contentController
        let webView = CBWebView(frame: .zero, configuration: config)
        webView.translatesAutoresizingMaskIntoConstraints = false
        return webView
    }()
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    func setupView() {
        webView.delegate = self
        addSubview(webView)
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: topAnchor),
            webView.leadingAnchor.constraint(equalTo: leadingAnchor),
            webView.bottomAnchor.constraint(equalTo: bottomAnchor),
            webView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
}

extension CBNavigator: CBKWKDelegate {
    public func urlRequested(url: String) {
        self.urlRequested = url
    }
}
