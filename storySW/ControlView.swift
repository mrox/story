//
//  ControlView.swift
//  storySW
//
//  Created by Tran Trung Tuyen on 04/02/2016.
//  Copyright © 2016 Tran Trung Tuyen. All rights reserved.
//

import UIKit


@objc protocol ControlDelegate {
    optional func closeDidTouch()
    optional func bookmarkedDidTouch()
    optional func fontDidTouch()
    optional func bookmarkDidTouch()
    optional func listChaptersDidTouch()
    
}

class ControlView: UIView {

    weak var delegate:ControlDelegate?
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var titleLabelView: UILabel!
    @IBOutlet weak var sliderView: UISlider!
    
    @IBAction func listChaptersDidTouch(sender: AnyObject) {
    }
    
    @IBAction func bookmarkedDidTouch(sender: AnyObject) {
    }
    
    @IBAction func fontDidTouch(sender: AnyObject) {
        self.delegate?.fontDidTouch!()
    }
    

    @IBAction func bookmarkDidTouch(sender: AnyObject) {
    }
    
    
    @IBAction func closeDidTouch(sender: AnyObject) {
        self.delegate?.closeDidTouch!()
    }
    
    class func instanceFromNib() -> ControlView {
        
        return UINib(nibName: "ControlView", bundle: nil).instantiateWithOwner(nil, options: nil)[0] as! ControlView
    }
    
    func configView(){
        self.topView.addBorder(.Bottom, color: UIColor.lightGrayColor(), width: 0.5)
        self.bottomView.addBorder(.Top, color: UIColor.lightGrayColor(), width: 0.5)
    }
    

}







