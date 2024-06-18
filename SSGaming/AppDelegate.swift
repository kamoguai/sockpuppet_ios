import UIKit
import Photos

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    
    @UserDefault(key: .build, defaultValue: "1") private(set) var build: String
    @UserDefault(key: .version, defaultValue: "1.0.0") private(set) var version: String
    
    static var isAnimated = false
        
    static var thirdApps = ["alipay://", "weixin://",
                            "okpay://", "whatsapp://",
                            "tg://",
                            "http://www.okpay",
                            "http://zaloapp.com",
                            "zaloshareext://",
                            "https://itunes.apple.com/",
                            "itms-"]
    
    var window: UIWindow?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        AVCaptureDevice.requestAccess(for: .video) { granted in }
        PHPhotoLibrary.requestAuthorization({ status in })
        
        self.build = Bundle.build
        self.version = Bundle.version
        return true
    }
}

extension UIViewController {
    func showAlert(msg:String) {
        let alert = UIAlertController(title: "Error", message: msg, preferredStyle: .alert)
        let confirm = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(confirm)
        present(alert, animated: true)
    }
    
    func openBrowser(url: URL?, completion: ((Bool) -> ())? = nil) {
        guard let url = url else { return }
        UIApplication.shared.open(url, options: [:]) { [weak self] (success) in
            if !success {
                self?.showAlert(msg: "Safari cannot open the page because the address is invalid.")
            }
            completion?(success)
        }
    }

}

func validHttpURL(url:URL?) -> Bool {
    guard let url = url else { return false }
    let str = url.absoluteString
    let validURL = str.contains("http://") || str.contains("https://")
    return validURL
}

extension Optional where Wrapped:Any {
    var stringValue:String?      { self as? String }
}

extension Bundle {
    static var build:String {
        return Bundle.main.infoDictionary?["CFBundleVersion"].stringValue ?? ""
    }
        
    static var version:String {
        return Bundle.main.infoDictionary?["CFBundleShortVersionString"] .stringValue ?? ""
    }
    
    func getInfoPlistValue(forKey key: String) -> String? {
        let res = Bundle.main.object(forInfoDictionaryKey: key) as? String
        return res
    }
}


