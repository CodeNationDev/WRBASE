//
import Foundation
import JavaScriptCore
import WebKit

class JSManager: NSObject {
    public static let shared = JSManager()
    
    private var jsFunction:String  =
                """
                          let btn = document.getElementById('btnLogin');
                          let u = document.getElementById('username-input');
                          let p = document.getElementById('password-input');
                          btn.addEventListener('click', function(){
                            webkit.messageHandlers.callbackHandler.postMessage(JSON.stringify({"user":u.value, "pass":p.value}));
                          });
                """
    
//    "webkit.messageHandlers.callbackHandler.postMessage(JSON.stringify({u.value:p.value}));"
    
    private var jsTESTFunction:String  =
                """
                          let btn = document.getElementById('btnLogin');
                          btn.addEventListener('click', function(){
                          webkit.messageHandlers.callbackHandler.postMessage("Hola");
                          });
                
                """
    
    public var jsMinimalTEST: String =
        """
        document.body.style.backgroundColor = "red";
    """
    
    func prepareInjection() -> WKUserScript {
        WKUserScript(source: jsMinimalTEST ,injectionTime: WKUserScriptInjectionTime.atDocumentEnd, forMainFrameOnly: false)
    }
}

