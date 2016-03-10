//
//  ParagraphView.swift
//  storySW
//
//  Created by Tran Trung Tuyen on 09/03/2016.
//  Copyright © 2016 Tran Trung Tuyen. All rights reserved.
//

import UIKit

let FONTMINUS = "FONTMINUSNOTIFI"
let FONTPLUS = "FONTPLUSNOTIFI"
let FONTCHANGE = "FONTFAMILYCHANGENOTIFI"

class ParagraphView: UIView {
    @IBOutlet weak var georgiaButton: UIButton!
    @IBOutlet weak var timeNewRomanButton: UIButton!
    @IBOutlet weak var helveticaButton: UIButton!

    @IBOutlet weak var bgView: UIView!
    
    let prefs = NSUserDefaults.standardUserDefaults()
    
    @IBAction func fontMinusDidTouch(sender: AnyObject) {
        NSNotificationCenter.defaultCenter().postNotificationName(FONTMINUS, object: self)
    }
    
    @IBAction func fontPlusDidTouch(sender: AnyObject) {
        NSNotificationCenter.defaultCenter().postNotificationName(FONTPLUS, object: self)
    }
    
    @IBAction func fontGeorgiaDidTouch(sender: AnyObject) {
        prefs.setValue(GEORGIAKEY, forKey: FONT_FAMILY_DEFAULT_KEY)
        self.changeFontFamily()
        NSNotificationCenter.defaultCenter().postNotificationName(FONTCHANGE, object: self)
    }
    
    @IBAction func fontTimeNewRomanDidTouch(sender: AnyObject) {
        prefs.setValue(TIMENEWROMANKEY, forKey: FONT_FAMILY_DEFAULT_KEY)
        self.changeFontFamily()
        NSNotificationCenter.defaultCenter().postNotificationName(FONTCHANGE, object: self)
    }
    
    @IBAction func fontHelveticaDidTouch(sender: AnyObject) {
        prefs.setValue(HELVETICAKEY, forKey: FONT_FAMILY_DEFAULT_KEY)
        self.changeFontFamily()
        NSNotificationCenter.defaultCenter().postNotificationName(FONTCHANGE, object: self)
    }
    
    @IBAction func whiteStyleDidTouch(sender: AnyObject) {
        prefs.setValue(WHITESTYLE, forKey: READER_STYLE_DEFAULT_KEY)
        NSNotificationCenter.defaultCenter().postNotificationName(READER_STYLE_DEFAULT_KEY, object: self)
    }
    
    @IBAction func sepiaStyleDidTouch(sender: AnyObject) {
        prefs.setValue(SEPIASTYLY, forKey: READER_STYLE_DEFAULT_KEY)
        NSNotificationCenter.defaultCenter().postNotificationName(READER_STYLE_DEFAULT_KEY, object: self)
    }
    
    @IBAction func blackStyleDidTouch(sender: AnyObject) {
        prefs.setValue(BLACKSTYLE, forKey: READER_STYLE_DEFAULT_KEY)
        NSNotificationCenter.defaultCenter().postNotificationName(READER_STYLE_DEFAULT_KEY, object: self)

    }
    
    class func instanceFromNib() -> ParagraphView {
        let view = UINib(nibName: "ParagraphView", bundle: nil).instantiateWithOwner(nil, options: nil)[0] as! ParagraphView
        view.frame = UIScreen.mainScreen().bounds
        view.changeFontFamily()
        return view
    }

    
    func changeFontFamily(){
        
        let fontFamily = prefs.integerForKey(FONT_FAMILY_DEFAULT_KEY)
        
        self.georgiaButton.setTitleColor(UIColor.lightGrayColor(), forState: .Normal)
        self.timeNewRomanButton.setTitleColor(UIColor.lightGrayColor(), forState: .Normal)
        self.helveticaButton.setTitleColor(UIColor.lightGrayColor(), forState: .Normal)
        
        if (fontFamily == GEORGIAKEY) {
            self.georgiaButton.setTitleColor(UIColor.belizeHoleColor(), forState: .Normal)
        }
        if (fontFamily == TIMENEWROMANKEY) {
            self.timeNewRomanButton.setTitleColor(UIColor.belizeHoleColor(), forState: .Normal)
        }
        if (fontFamily == HELVETICAKEY) {
            self.helveticaButton.setTitleColor(UIColor.belizeHoleColor(), forState: .Normal)
        }

    }

}
