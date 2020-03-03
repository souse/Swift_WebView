import WebKit
import UIKit

@objc class GzWebViewControl: NSObject {
    var callBackValueHandle: ((Any) -> Void)?
    
    private var webView: WKWebView
    private weak var delegate: WebViewControllerProtocol?
    private var handlers = [String : GzNativeHandler]()
    private var completionHandles: [() -> Void] = []
    
    @objc init(webView: WKWebView, delegate: WebViewControllerProtocol) {
        self.webView = webView
        self.delegate = delegate
        super.init()
        
        webView.uiDelegate = self
        webView.navigationDelegate = self
        webView.configuration.userContentController.add(self, name: "rociOS")
        
        registerHandler(CommonWebHandle(controller: delegate))
    }
    
    /// 加载web界面
    /// - Parameter urlString: 加载链接
    func loadUrl(_ urlString: String) -> Void {
        guard let url = URL(string: urlString) else {
            assert(false, "url 无效")
            return
        }
        
        webView.load(URLRequest(url: url))
    }
    
    /// 原生调用js函数
    ///
    /// - Parameters:
    ///   - name: 函数名
    ///   - callbackId: 回调名
    ///   - param: 参数
    @objc func nativeCall(name: String, callbackId: String, param: [AnyHashable: Any]?) {
        DispatchQueue.main.async {
            do {
                let data =  try JSONSerialization.data(withJSONObject: param ??  [], options: [])
                let eval = "window.rocNative.__nativeCall(\"\(name)\", \"\(callbackId)\", \(String(data: data, encoding: .utf8) ?? "null"))"
                
                print(eval)
                self.webView.evaluateJavaScript(eval, completionHandler: { o, err in
                    if err != nil {
                        print(err?.localizedDescription ?? "")
                    }
                })
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    @objc func callFunction(_ name: String, param: [AnyHashable: Any]? = nil) {
        func toJson(_ dic: [AnyHashable: Any]?) -> String {
            if dic == nil {
                return "null"
            } else {
                do {
                    let data = try JSONSerialization.data(withJSONObject: dic ?? [], options: [])
                    
                    return String(data: data, encoding: .utf8)!
                } catch {
                    print("json error \(error.localizedDescription)")
                    return "null"
                }
            }
        }
        
        let eval = "window.rocNative.__nativeCall(\"\",\"\(name)\",\(toJson(param)))"
        
        self.webView.evaluateJavaScript(eval, completionHandler: { o, err in
            if err != nil {
                print(err?.localizedDescription ?? "")
            }
        })
    }
    
    @objc func registerHandler(_ handler: GzNativeHandler) {
        for n in handler.names {
            handlers[n] = handler
        }
    }
}

extension GzWebViewControl : WKNavigationDelegate {}
extension GzWebViewControl : WKUIDelegate {
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        completionHandles.append(completionHandler)
        let alertController = UIAlertController(title: "HTML的警告框", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: { action in
            for handle in self.completionHandles {
                handle()
            }
            self.completionHandles.removeAll()
        })
        guard webView.window != nil else { return }
        alertController.addAction(action)
        delegate?.present(alertController, animated: true, completion: nil)
    }
    
    func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
        let alertController = UIAlertController(title: "HTML的确认框", message: message, preferredStyle: .alert)
        let action0 = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            completionHandler(false)
        }
        let action1 = UIAlertAction(title: "OK", style: .default) { (action) in
            completionHandler(true)
        }
        
        alertController.addAction(action0)
        alertController.addAction(action1)
        delegate?.present(alertController, animated: true, completion: nil)
    }
}
extension GzWebViewControl : WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if let json = message.body as? String {
            handleRoute(json)
        }
    }
    
    @objc func handleRoute(_ json: String) {
        guard let data = json.data(using: .utf8), let obj = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else {
            assert(false, "解析 json 出错")
            return
        }
        guard let name = obj["name"] as? String else {
            assert(false, "name 为空")
            return
        }
        guard let param = obj["param"] as? [String: Any] else {
            assert(false, "param 为空")
            return
        }
        let callback = obj["callbackId"] as? String
        
        guard let handler = handlers[name] else {
            let data: [String: Any] = ["name": name, "param": param]
            
            callBackValueHandle?(data)
            return
        }
        
        handler.handle(view: webView, name: name, param: param, callback: { (err: String?, param: [AnyHashable: Any]?) in
            
            self.nativeCall(name: name, callbackId: callback ?? "", param: param)
        })
    }
}
