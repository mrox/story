//
//  Tabbar.swift
//  storySW
//
//  Created by Tran Trung Tuyen on 28/01/2016.
//  Copyright © 2016 Tran Trung Tuyen. All rights reserved.
//

import Foundation
import UIKit

extension UITabBar {
    
//    override public func sizeThatFits(size: CGSize) -> CGSize {
//        super.sizeThatFits(size)
//        var sizeThatFits = super.sizeThatFits(size)
//        sizeThatFits.height = 46
//        return sizeThatFits
//    }
    
    override public func valueForKey(key: String) -> AnyObject? {
        super.valueForKey(key)
        self.setValue(true, forKey: "_hidesShadow")
        return nil
    }
    
}