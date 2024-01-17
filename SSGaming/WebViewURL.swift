import UIKit

struct WebViewURL {
    
    private(set) var route:Route
    
    var url:String { "https://" + route.rawValue }
    
    init(_ route: WebViewURL.Route) {
        self.route = route
    }
    
    struct Route:RawRepresentable, Hashable {
        
        let rawValue:String
        
        init(rawValue: String) {
            self.rawValue = rawValue
        }
    }
}


extension WebViewURL.Route {
//    static let ssapp0com = WebViewURL.Route(rawValue: "ssapp0.com")
    static let ssapp0com = WebViewURL.Route(rawValue: "882792.com")
}


