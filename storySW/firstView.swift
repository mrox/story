//
//  firstView.swift
//  storySW
//
//  Created by Tran Trung Tuyen on 10/03/2016.
//  Copyright © 2016 Tran Trung Tuyen. All rights reserved.
//

import UIKit

class firstView: UIView {

    class func instanceFromNib() -> firstView {
        let view = UINib(nibName: "firstView", bundle: nil).instantiateWithOwner(nil, options: nil)[0] as! firstView
        view.frame = UIScreen.mainScreen().bounds
        return view
    }
    
    @IBOutlet weak var prevButton: ButtonExtender!
    @IBOutlet weak var nextButton: ButtonExtender!

    
}