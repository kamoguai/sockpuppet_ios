import UIKit
import MBProgressHUD


class ProgressView {
    static func show(duration:TimeInterval = 10){
        MBProgressHUD.showAdded(to: UIWindow.currentView, animated: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            MBProgressHUD.hide(for: UIWindow.currentView, animated: true)
        }
    }
    
    static func hide(){
        MBProgressHUD.hide(for: UIWindow.currentView, animated: true)
    }
}

extension UIWindow {
    static var currentController:UIViewController? {
        (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController
    }
    
    static var currentView:UIView {
        currentController?.view ?? UIView()
    }
}
