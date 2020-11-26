//
import Foundation
import UIKit
import WebKit

class CBWebView: WKWebView, WKNavigationDelegate, WKUIDelegate {
    
    public override init(frame: CGRect, configuration: WKWebViewConfiguration) {
        super.init(frame: frame, configuration: configuration)
        setupWK()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupWK()
    }
    
    func setupWK() {
        addObserver(self, forKeyPath: "URL", options: .new, context: nil)
        addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
        navigationDelegate = self
    }
    
    override public func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
        print("Loading...")
        
        if keyPath == #keyPath(WKWebView.estimatedProgress) {
            // When page load finishes. Should work on each page reload.
            if estimatedProgress == 1 {
                guard url != nil else {
                    return
                }
                debugPrint("### EP  \(url!.absoluteString)")
                LoggerManager.shared.log(message: "Navigation to: \(url!.absoluteString)")
            }
        }
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

