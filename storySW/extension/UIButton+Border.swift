import Foundation
import UIKit

public enum UIButtonBorderSide {
    case Top, Bottom, Left, Right
}

extension UIView {
    
    public func addBorder(side: UIButtonBorderSide, color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.CGColor
        
        switch side {
        case .Top:
            border.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: width)
        case .Bottom:
            border.frame = CGRect(x: 0, y: self.frame.size.height - width, width: self.frame.size.width, height: width)
        case .Left:
            border.frame = CGRect(x: 0, y: 0, width: width, height: self.frame.size.height)
        case .Right:
            border.frame = CGRect(x: self.frame.size.width - width, y: 0, width: width, height: self.frame.size.height)
        }
        
        self.layer.addSublayer(border)
    }
}

//extension UIView {
//    
//    public func addBorder(side: UIButtonBorderSide, color: UIColor, width: CGFloat) {
//        let border = CALayer()
//        border.backgroundColor = color.CGColor
//        
//        switch side {
//        case .Top:
//            border.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: width)
//        case .Bottom:
//            border.frame = CGRect(x: 0, y: self.frame.size.height - width, width: self.frame.size.width, height: width)
//        case .Left:
//            border.frame = CGRect(x: 0, y: 0, width: width, height: self.frame.size.height)
//        case .Right:
//            border.frame = CGRect(x: self.frame.size.width - width, y: 0, width: width, height: self.frame.size.height)
//        }
//        
//        self.layer.addSublayer(border)
//    }
//}