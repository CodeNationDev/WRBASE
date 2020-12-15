//
import Foundation
import JavaScriptCore
import WebKit

class JSManager: NSObject {
    public static let shared = JSManager()
    
    private var jsFunction:String  =
                "javascript:(function() { " +
                        "  let btn = document.getElementById('loginbtn');\n" +
                        "  let u = document.getElementById('username-input');" +
                        "  let p = document.getElementById('password-input');" +
                        "  btn.addEventListener('click', function(ev){\n" +
                        "    Android.saveUser(u.value);\n" +
                        "    Android.savePassword(p.value);\n" +
                        "  });\n" +
                        "})()"
    
    
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
        WKUserScript(source: jsTESTFunction ,injectionTime: WKUserScriptInjectionTime.atDocumentEnd, forMainFrameOnly: false)
    }
}

