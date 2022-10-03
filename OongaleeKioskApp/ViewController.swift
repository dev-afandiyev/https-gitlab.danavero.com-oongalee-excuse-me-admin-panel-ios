import UIKit
import WebKit
import UserNotifications

class ViewController: UIViewController {
    
    var webView: WKWebView = {
        let prefs = WKWebpagePreferences()
        prefs.allowsContentJavaScript = true
        let configuration = WKWebViewConfiguration()
        configuration.defaultWebpagePreferences = prefs
        let webView = WKWebView(frame: .zero,
        configuration: configuration)
        
        return webView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupWebView()
        view.addSubview(webView)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        if let currentUrl = webView.url {
            UserDefaults.standard.set(currentUrl, forKey: "url")
        }
    }
    
    func setupWebView() {
        
        if let savedUrl = UserDefaults.standard.url(forKey: "url") {
            webView.load(URLRequest(url: savedUrl))
        }else {
           guard let url = URL(string: "https://excuseme.oongalee.com/") else {return}
           webView.load(URLRequest(url: url))
        }
        webView.configuration.defaultWebpagePreferences.allowsContentJavaScript = true
        
        DispatchQueue.main.asyncAfter(deadline: .now()+5) {
            self.webView.evaluateJavaScript("document.body.innerHTML") { result, error in
                guard let html = result as? String, error == nil else {
                    return
                }
                print(html)
            }
        }
        
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        webView.frame = view.bounds
    }
    
}
