import UIKit
import WebKit

class NewWindow: UIViewController {
    deinit {
        print("deinit NewWindow")
        ProgressView.hide()
    }
    
    private var webView:WKWebView!
        
    private var didFinish = false
     
    var request:URLRequest?
    
    convenience init(request: URLRequest?) {
        self.init(nibName : nil, bundle : nil)
        self.request = request
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupWebView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ProgressView.show(duration: 2)
    }
}

extension NewWindow:WKNavigationDelegate, WKUIDelegate {
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        didFinish = false
        guard let url = webView.url else { return }
        print("NewWindow didStartProvisionalNavigation \(url.absoluteString)")
        guard AppDelegate.thirdApps.contains(url.absoluteString) else { return
        }
        openBrowser(url: url) { [weak self] (success) in
            guard success else { return }
            self?.dismiss(animated: true)
        }
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("NewWindow didFinish")
        ProgressView.hide()
        didFinish = true
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        guard let url = navigationAction.request.url else { return }
        print("NewWindow navigationAction  \(url)")
        if didFinish {
            openBrowser(url: url) { [weak self] (success) in
                decisionHandler(.cancel)
                print("\(!validHttpURL(url: url))")
                guard success, validHttpURL(url: url) == false else {
                    return
                }
                self?.dismiss(animated: true)
            }
        }else {
            decisionHandler(.allow)
        }
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        if let url = navigationResponse.response.url {
            print("NewWindow navigationResponse  \(url)")
        }
        decisionHandler(.allow)
    }
}

extension NewWindow {
    func setupWebView() {
        let configuration = WKWebViewConfiguration()
        configuration.allowsInlineMediaPlayback = true
        webView = WKWebView(frame: view.bounds, configuration: configuration)
        webView.scrollView.contentInsetAdjustmentBehavior = .never
        webView.configure(self, backgroundColor: .white)
        
        view.addSubview(webView)
        webView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        ])
        if let url = request?.url {
            print("NewWindow url \(url)")
        }else{
            print("NewWindow url is nil")
        }
        guard let request = request else { return }
        webView.load(request)
    }
}
