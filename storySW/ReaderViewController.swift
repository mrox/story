//
//  ReaderViewController.swift
//  storySW
//
//  Created by Tran Trung Tuyen on 02/02/2016.
//  Copyright © 2016 Tran Trung Tuyen. All rights reserved.
//

import UIKit


class ReaderViewController: UIViewController, ControlDelegate {

    var scrollView: UIScrollView!
    
    var chapter = Chapter()
    var textStorage = NSTextStorage()
    var layoutManager = NSLayoutManager()
    var content = NSMutableAttributedString()
    var controlView = ControlView()
    var controlIsHiden = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.scrollView = UIScrollView.init(frame: self.view.frame);
        self.scrollView.decelerationRate = UIScrollViewDecelerationRateFast
        self.scrollView.pagingEnabled = true
        self.scrollView.showsHorizontalScrollIndicator = false
        self.scrollView.showsVerticalScrollIndicator = false
        self.view.addSubview(self.scrollView)
        
        
        Chapter.getContent(chapter.id) { (result) -> Void in
            print(result)
            self.content = NSMutableAttributedString.init(string: result.content)
            self.styleReader()
        }
        
        let tapDetect = UITapGestureRecognizer.init(target: self, action: Selector("tapGesture"))
        self.scrollView.addGestureRecognizer(tapDetect)
        
        //add control view
        self.controlView = ControlView.instanceFromNib()
        self.controlView.delegate = self
        self.controlView.configView()
        self.controlView.frame = self.view.bounds
        self.controlView.alpha = 0.0
        self.view.addSubview(self.controlView)
        

        
    }
    
    
    func styleReader() {

        let fullRange = NSMakeRange(0, self.content.length)
        
        self.content.addAttribute(NSFontAttributeName, value: UIFont.systemFontOfSize(16.0), range: fullRange)
        
        let paragraphStyle       = NSMutableParagraphStyle()
        paragraphStyle.alignment = NSTextAlignment.Justified
        
        self.content.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle, range: fullRange)
        
        
        self.configReaderView(self.content)
    }
    
    func configReaderView(content: NSAttributedString){
        
        
        self.textStorage = NSTextStorage.init(attributedString: content)
        self.layoutManager = NSLayoutManager.init()
        textStorage.addLayoutManager(layoutManager)
        self.layoutTextContainers()
    }
    
    func layoutTextContainers() {
        var lastRenderedGlyph = 0
        var currentXOffset:CGFloat = 10
        
        while (lastRenderedGlyph < self.layoutManager.numberOfGlyphs) {
            let textViewFrame = CGRectMake(currentXOffset,
                                            10,
                                            CGRectGetWidth(self.view.frame)-20,
                                            CGRectGetHeight(self.view.frame)-20)
            let columnSize = CGSizeMake(CGRectGetWidth(textViewFrame), CGRectGetHeight(textViewFrame))
            
            let textContainer = NSTextContainer.init(size: columnSize)
            
            self.layoutManager.addTextContainer(textContainer)
            
            let textView = UITextView.init(frame: textViewFrame, textContainer: textContainer)
            
            textView.scrollEnabled = false
            textView.selectable = true
            
            self.scrollView.addSubview(textView)
            
            currentXOffset += CGRectGetWidth(self.view.frame)
            
            lastRenderedGlyph = NSMaxRange(self.layoutManager.glyphRangeForTextContainer(textContainer))
            
        }
        // Need to update the scrollView size
        let contentSize = CGSizeMake(currentXOffset-10, CGRectGetHeight(self.scrollView.bounds));
        self.scrollView.contentSize = contentSize;
    }
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - touch
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.tapGesture()
    }
    
    func tapGesture(){
        self.controlIsHiden = !self.controlIsHiden
        
        if !self.controlIsHiden {
            self.showControl()
        }
        else {
            self.hideControl()
        }
    }
    
    func showControl() {
        UIApplication.sharedApplication().setStatusBarHidden(false, withAnimation: .Fade)
        
        UIView.animateWithDuration(0.2, animations: { () -> Void in
            
            self.controlView.alpha = 1.0
            
        })
    }
    
    func hideControl() {
        UIApplication.sharedApplication().setStatusBarHidden(true, withAnimation: .Fade)
        
        UIView.animateWithDuration(0.2, animations: { () -> Void in
            
            self.controlView.alpha = 0.0
            
        })
    }
    
    // MARK: control
    func closeDidTouch() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
