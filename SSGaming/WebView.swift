//
//  WebView.swift
//  WebApp
//
//  Created by GMCD on 2022/8/8.
//  Copyright © 2022 GMCD. All rights reserved.
//

import UIKit
import WebKit
import Network
import NetworkExtension

protocol WebViewDelegate:AnyObject {
    func webview(_ webView:WebView, openBrowser url: URL?)
    func webview(_ webView:WebView, needOpenNewWindow request: URLRequest?)
    func webview(_ webView:WebView, didFailWithError error: Error)
}

class WebView: UIView {
        
    var imageView:UIImageView!
    
    var bottomView:BottomBar = .fromNib()
        
    var webView: WKWebView!
        
    var actions = [String]()
    
    var needOpenNewWindow = false
        
    var delegate:WebViewDelegate?
    
    var urlStr:String { WEBVIEW_URL }
    
    var request:URLRequest {
        var urlComponents = URLComponents(string: urlStr)!
        urlComponents.queryItems = [URLQueryItem(name: "deviceType", value: "app")]
        return URLRequest(url: urlComponents.url!, timeoutInterval: 15)
    }
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        if enableProxy {
            selectedProxy()
        }
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        if enableProxy {
            selectedProxy()
        }
        setupViews()
    }
    
    func load(animate: Bool = false) {
        webView?.load(request)
        guard animate else { return }
        alphaAnimation()
    }
    
    func load(request:URLRequest?) {
        guard let request = request else { return }
        webView?.load(request)
    }
    
    func reloadPage() {
        load(request: request)
    }
    
    func goBack() {
        guard let webView = webView else { return }
        guard webView.canGoBack else { return }
        webView.goBack()
    }
    
    func goForward() {
        guard let webView = webView else { return }
        guard webView.canGoForward else { return }
        webView.goForward()
    }
    
    func alphaAnimation() {
        guard !AppDelegate.isAnimated else { return }
        UIView.animate(withDuration: 2.5, animations: { [weak self] in
            self?.imageView?.alpha = 0
        }) { [weak self] (_) in
            guard self?.webView.alpha == 0 else { return }
            self?.webView.alpha = 1
        }
        AppDelegate.isAnimated = true
    }
}

extension WebView:WKNavigationDelegate, WKUIDelegate {
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        guard let url = webView.url else { return }
        print("didStartProvisionalNavigation \(url)")
    }
    
    func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
        guard let url = webView.url else { return }
        print("RedirectForProvisionalNavigation \(url)")
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("didFinish")
        ProgressView.hide()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print("didFail \(error)")
        guard (error as NSError).code != NSURLErrorCancelled else { return }
        delegate?.webview(self, didFailWithError: error)
    }
    
    func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        guard let serverTrust = challenge.protectionSpace.serverTrust else {
            return completionHandler(.useCredential, nil)
        }
        let exceptions = SecTrustCopyExceptions(serverTrust)
        SecTrustSetExceptions(serverTrust, exceptions)
        completionHandler(.useCredential, URLCredential(trust: serverTrust))
    }
    
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        print("***createWebViewWith \(navigationAction.request)")
        
        if navigationAction.targetFrame == nil {
            configuration.allowsInlineMediaPlayback = true
            self.needOpenNewWindow = !validHttpURL(url: navigationAction.request.url)
            let webView = WKWebView(frame: bounds, configuration: configuration)
            webView.configure(self, backgroundColor: .white)
            
            self.webView = webView
            return webView
        }
        needOpenNewWindow = false
        return nil
    }
    
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        print("runJavaScript message \(message)")
        completionHandler()
    }
    
    func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
        print("runJavaScriptConfirmPanelWithMessage")
        completionHandler(true)
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        guard let url = navigationAction.request.url else { return }
        print("navigationAction  \(url)")
        let urlString = url.absoluteString
        let about = "about:"
        
        if !urlString.hasPrefix(about) && !validHttpURL(url: url) {
            decisionHandler(.cancel)
            delegate?.webview(self, openBrowser: url)
            return
        }
        
        actions.append(urlString.lowercased())
        if needOpenNewWindow {
            print("url.absoluteString \(urlString)")
            if urlString.hasPrefix(about) {
                ProgressView.show()
            }else{
                needOpenNewWindow = false
                delegate?.webview(self, needOpenNewWindow: navigationAction.request)
            }
        }else{
            if actions.count > 2 && actions.last == urlStr.lowercased() {
                decisionHandler(.cancel)
                return
            }
        }
        decisionHandler(.allow)
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        if let url = navigationResponse.response.url {
            print("navigationResponse  \(url)")
        }
        decisionHandler(.allow)
    }
}

//extension WebView: WKScriptMessageHandler {
//    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
//        guard let event = JSEvent(rawValue: message.name) else { return }
//        switch event {
//        case .accessCamera:
//            break
//        case .accessPhotos:
//            break
//        case .accessLocation:
//            break
//        case .accessMicrophone:
//            break
//        }
//    }
//}

extension WebView: BottomBarDelegate {
    func bottomBarDidTappedHomeButton(_ bottomBar: BottomBar) {
        actions.removeAll()
        load()
        ProgressView.show(duration: 1)
    }
    
    func bottomBarDidTappedRefreshButton(_ bottomBar: BottomBar) {
        reloadPage()
        ProgressView.show(duration: 1)
    }
    
    func bottomBarDidTappedGoBackButton(_ bottomBar:BottomBar) { goBack() }
    
    func bottomBarDidTappedGoForwardButton(_ bottomBar:BottomBar) { goForward() }
}

private extension WebView {
    func setupViews() {
        backgroundColor = .blackColor
        let emptyView = UIView()
        emptyView.backgroundColor = .emptyColor
        
        let user = WKUserContentController()
//        user.add(self, event: .accessCamera)
        
        let config = WKWebViewConfiguration()
        config.userContentController = user
        config.allowsInlineMediaPlayback = true
        /// 在開關在------ Config ------.swift
        if enableProxy {
            print("host: \(ConfigVariables.proxyHost) , port: \(ConfigVariables.proxyPort), username: \(ConfigVariables.proxyUserName), password: \(ConfigVariables.proxyPassword)")
            
            config.addProxyConfig((ConfigVariables.proxyHost, ConfigVariables.proxyPort))
        }
       
        webView = WKWebView(frame: UIScreen.main.bounds, configuration: config)
//        webView.customUserAgent = "iOS"
        
        bottomView.delegate = self
        
        imageView = UIImageView()
        imageView.contentMode = imageViewContentMode
        if let image = UIImage(named: "LaunchImage") {
            imageView.image = image
        }
        
        webView.alpha = 0
        webView.configure(self, backgroundColor: .blackColor)
        
        addSubview(emptyView)
        addSubview(webView)
        addSubview(bottomView)
        addSubview(imageView)
        
        webView.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        emptyView.translatesAutoresizingMaskIntoConstraints = false
        bottomView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0),
            
            emptyView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            emptyView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            emptyView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: 0),
            emptyView.heightAnchor.constraint(equalToConstant: 50),
            
            bottomView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            bottomView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            bottomView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: 0),
            bottomView.heightAnchor.constraint(equalToConstant: 50),
            
            webView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 0),
            webView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            webView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            webView.bottomAnchor.constraint(equalTo: bottomView.topAnchor, constant: 0)
        ])
    }
}
