import UIKit

protocol BottomBarDelegate:AnyObject {
    func bottomBarDidTappedHomeButton(_ bottomBar:BottomBar)
    func bottomBarDidTappedRefreshButton(_ bottomBar:BottomBar)
    
    func bottomBarDidTappedGoBackButton(_ bottomBar:BottomBar)
    func bottomBarDidTappedGoForwardButton(_ bottomBar:BottomBar)
}


class BottomBar: UIView {
    
    weak var delegate:BottomBarDelegate?
    
    @IBAction private func buttonActions(sender:UIButton){
        switch sender.tag {
        case 0:
            delegate?.bottomBarDidTappedHomeButton(self)
        case 1:
            delegate?.bottomBarDidTappedGoBackButton(self)
        case 2:
            delegate?.bottomBarDidTappedGoForwardButton(self)
        case 3:
            delegate?.bottomBarDidTappedRefreshButton(self)
        default:
            break
        }
    }
}

extension UIView {
    class func fromNib<T: UIView>() -> T {
        guard let view = Bundle.main.loadNibNamed("\(T.self)", owner: nil, options: nil)?.first as? T else {
            return T()
        }
        return view
    }
}
