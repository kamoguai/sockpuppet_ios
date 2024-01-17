import UIKit
import WebKit

extension WKWebView {
    func configure<T: WKUIDelegate & WKNavigationDelegate>(_ observer: T,
                                                           backgroundColor: UIColor) {
        self.isOpaque = false
        self.uiDelegate = observer
        self.backgroundColor = backgroundColor
        self.navigationDelegate = observer
        self.scrollView.bounces = false
        self.allowsLinkPreview = true
    }
}

extension WKUserContentController {
    func add<T: WKScriptMessageHandler>(_ observer: T, event: JSEvent){
        self.add(observer, name: event.name)
    }
    
    func add<T: WKScriptMessageHandler>(_ observer: T, events: [JSEvent]){
        events.forEach {
            self.add(observer, name: $0.name)
        }
    }
}

