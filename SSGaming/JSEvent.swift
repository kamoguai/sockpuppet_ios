import UIKit

enum JSEvent: String {
    case accessCamera
    case accessPhotos
    case accessLocation
    case accessMicrophone
    
    var name:String {
        switch self {
        case .accessCamera:       return "accessCamera"
        case .accessPhotos:       return "accessPhotos"
        case .accessLocation:     return "accessLocation"
        case .accessMicrophone:   return "accessMicrophone"
        }
    }
}
