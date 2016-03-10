//
//  LastView.swift
//  storySW
//
//  Created by Tran Trung Tuyen on 10/03/2016.
//  Copyright © 2016 Tran Trung Tuyen. All rights reserved.
//

import UIKit

class LastView: UIView {

    class func instanceFromNib(frame: CGRect) -> LastView {
        let view = UINib(nibName: "LastView", bundle: nil).instantiateWithOwner(nil, options: nil)[0] as! LastView
        view.frame = frame
        return view
    }
    @IBOutlet weak var prevChapter: ButtonExtender!
    @IBOutlet weak var nextChapter: ButtonExtender!


}
