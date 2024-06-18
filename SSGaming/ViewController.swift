import UIKit
import WebKit
import Foundation
class ViewController: UIViewController {
  
    private var webView:WebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let hn = Bundle.main.getInfoPlistValue(forKey: "HostName"){
            print(hn)
        }
        setupWebView()
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        webView?.load(animate: true)
    }
    

}

extension ViewController: WebViewDelegate {
    func webview(_ webView:WebView, openBrowser url: URL?) {
        openBrowser(url: url)
    }
    
    func webview(_ webView:WebView, needOpenNewWindow request: URLRequest?){
        let page = NewWindow(request: request)
        present(page, animated: true)
    }
    
    func webview(_ webView: WebView, didFailWithError error: Error) {
        showAlert(error: error)
    }
    
    func showAlert(error:Error) {
        let message = error.localizedDescription.components(separatedBy: "error: ").last
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let confirm = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(confirm)
        present(alert, animated: true)
    }
}

extension ViewController {
    func setupWebView() {
        webView = WebView()
        webView.delegate = self
        view.addSubview(webView)
        webView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        ])
    }
}

