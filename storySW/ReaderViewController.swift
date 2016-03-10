//
//  ReaderViewController.swift
//  storySW
//
//  Created by Tran Trung Tuyen on 02/02/2016.
//  Copyright © 2016 Tran Trung Tuyen. All rights reserved.
//

import UIKit
import WebKit

internal let SCROLL_DURATION = 0.2

//reader View
class ReaderViewController: UIViewController, ControlDelegate, UIGestureRecognizerDelegate, UIWebViewDelegate {
    
    var chapter = Chapter()
    var controlView = ControlView() {
        didSet {
            self.controlView.delegate = self
            self.controlView.configView()
            self.controlView.frame = self.view.bounds
            self.hideControl()
        }
    }
    
    var webView = UIWebView() {
        didSet {
            self.webView.delegate = self
            self.webView.scrollView.bounces = false
            self.webView.scrollView.pagingEnabled = true
            self.webView.scrollView.showsHorizontalScrollIndicator = false
            self.webView.scrollView.showsVerticalScrollIndicator = false
            self.webView.scrollView.decelerationRate = UIScrollViewDecelerationRateFast
            self.webView.scrollView.delegate = self
        }
    }
    
    var paragraphView = ParagraphView()
    var controlIsHiden = true
    var scrolling = false
    let prefs = NSUserDefaults.standardUserDefaults()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.webView = UIWebView(frame: self.view.bounds)
        self.view.addSubview(self.webView)
        
        
        Chapter.getContent(chapter.id) { (result) -> Void in
            
            self.chapter = result
            self.chapter.content = self.chapter.content.stringByReplacingOccurrencesOfString("\n", withString: "<br />")
            self.htmlText()
            
        }
        
        let tapDetect = UITapGestureRecognizer.init(target: self, action: Selector("tapGesture:"))
        tapDetect.delegate = self
        self.webView.addGestureRecognizer(tapDetect)
        
        //add control view
        self.controlView = ControlView.instanceFromNib()
        self.view.addSubview(self.controlView)
        
        
        //Create Paragraph View
        self.paragraphView = ParagraphView.instanceFromNib()
        
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "fontMinus", name: FONTMINUS, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "fontPlus", name: FONTPLUS, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "fontFamilyChange", name: FONTCHANGE, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "styleChange", name: READER_STYLE_DEFAULT_KEY, object: nil)
        
    }
    
    //MARK: - Controls
    
    func closeDidTouch() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //show Paragraph View
    func fontDidTouch() {
        self.controlView.addSubview(self.paragraphView)
    }
    
    
    func fontMinus() {
        
        var font = prefs.floatForKey("fontSize")
        
        font -= 2
        
        print("FONT MINUS: \(font)")
        
        if font <= 14 {
            return
        }
        
        prefs.setFloat(font, forKey: "fontSize")
        
        self.styleReaderView()
    }
    
    func fontPlus() {
        
        var font = prefs.floatForKey("fontSize")
        
        font += 2
        
        print("FONT PLUS : \(font)")
        
        if font >= 24 {
            return
        }
        
        prefs.setFloat(font, forKey: "fontSize")
        
        self.styleReaderView()
    }
    
    func fontFamilyChange() {
        self.styleReaderView()
    }
    
    func styleChange() {
        self.styleReaderView()
        
    }
    
    func nextPage(){
        var currentPoint = self.webView.scrollView.contentOffset
        
        if currentPoint.x <= (self.webView.scrollView.contentSize.width - self.webView.bounds.width) && !self.scrolling {
            self.scrolling = !self.scrolling
            currentPoint.x += self.webView.bounds.width
            let rect = CGRectMake(currentPoint.x, 0, self.webView.bounds.width, self.webView.bounds.height)
            
            UIView.animateWithDuration(SCROLL_DURATION, animations: { () -> Void in
                self.webView.scrollView.scrollRectToVisible(rect, animated: false)
            }, completion: { (complete) -> Void in
                self.scrolling = !self.scrolling
                self.updatePage()
            })
            
        }
    }
    
    func previousPage(){
        
        var currentPoint = self.webView.scrollView.contentOffset
        
        if currentPoint.x <= (self.webView.scrollView.contentSize.width - self.webView.bounds.width) && !self.scrolling {
            self.scrolling = !self.scrolling
            currentPoint.x -= self.webView.bounds.width
            let rect = CGRectMake(currentPoint.x, 0, self.webView.bounds.width, self.webView.bounds.height)
            
            UIView.animateWithDuration(SCROLL_DURATION, animations: { () -> Void in
                self.webView.scrollView.scrollRectToVisible(rect, animated: false)
                }, completion: { (complete) -> Void in
                    self.scrolling = !self.scrolling
                    self.updatePage()
            })
            
        }
        
    }
    
    func updatePage(){
        let maxPage = floor(self.webView.scrollView.contentSize.width/self.webView.bounds.width) + 1
        let currentPage = floor(self.webView.scrollView.contentOffset.x/self.webView.bounds.width) + 1
        
        self.controlView.sliderView.maximumValue = Float(maxPage)
        self.controlView.sliderView.value = Float(currentPage)
        self.controlView.pageLabel.text = "\(Int(currentPage))/\(Int(maxPage))"
        
    }
    
    func pageChange(page: Int) {
        let point = CGPointMake(CGFloat(page * Int(self.webView.bounds.width)), 0)
        self.webView.scrollView.contentOffset = point
        self.updatePage()
    }
    
    //MARK: WebView Contents
    
    func htmlText() {
        
        let HTML = NSBundle.mainBundle().URLForResource("reader", withExtension: "html")
        
        do {
            var content = try NSString(contentsOfFile: (HTML?.path)!, encoding: NSUTF8StringEncoding)
            content = content.stringByReplacingOccurrencesOfString("|TITLE|", withString: self.chapter.name)
            content = content.stringByReplacingOccurrencesOfString("|CONTENT|", withString: self.chapter.content)
            
            self.webView.loadHTMLString(content as String, baseURL: HTML)
            
        }
        catch {
            print("error load local file")
        }
        
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        self.styleReaderView()
        self.fixContentSize()

    }
    
    func styleReaderView(){
        
        webView.stringByEvaluatingJavaScriptFromString("changeFontSize(\(prefs.floatForKey("fontSize")));")
        webView.stringByEvaluatingJavaScriptFromString("changeFontFamily(\(prefs.integerForKey(FONT_FAMILY_DEFAULT_KEY)));")
        webView.stringByEvaluatingJavaScriptFromString("changeReaderStyle(\(prefs.integerForKey(READER_STYLE_DEFAULT_KEY)));")
        
        if(prefs.integerForKey(READER_STYLE_DEFAULT_KEY) == BLACKSTYLE) {
            self.webView.scrollView.backgroundColor = UIColor.blackColor()
            self.webView.backgroundColor = UIColor.blackColor()
            self.view.backgroundColor = UIColor.blackColor()
        }
            
        else if(prefs.integerForKey(READER_STYLE_DEFAULT_KEY) == WHITESTYLE){
            self.webView.scrollView.backgroundColor = UIColor.whiteColor()
            self.webView.backgroundColor = UIColor.whiteColor()
            self.view.backgroundColor = UIColor.whiteColor()
        }
        else {
            self.webView.scrollView.backgroundColor = UIColor(red:0.98, green:0.95, blue:0.91, alpha:1)
            self.webView.backgroundColor = UIColor(red:0.98, green:0.95, blue:0.91, alpha:1)
            self.view.backgroundColor = UIColor(red:0.98, green:0.95, blue:0.91, alpha:1)
        }
        
        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Touch
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        let touch = touches.first! as UITouch
        self.tapGesture(touch)
        
    }
    
    func tapGesture(recognizer: UITouch){

        let location = recognizer.locationInView(self.view)
        
        if (!self.controlIsHiden) {
            self.controlIsHiden = !self.controlIsHiden
            self.hideControl()
        }
        else {
            if (location.x <= 100) {
                self.previousPage()
            }
            else if (location.x >= (self.view.bounds.width-100)) {
                self.nextPage()
            }
            else {
                self.controlIsHiden = !self.controlIsHiden
                self.showControl();
            }
        }

    }
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    // MARK: Show/Hide Controls
    
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
            self.paragraphView.removeFromSuperview()
            
        })
    }
    
    func fixContentSize(){
        let screenWidth = self.view.bounds.width
        var size = self.webView.scrollView.contentSize
        let space = screenWidth-(size.width % screenWidth)
        size.width =  self.webView.scrollView.contentSize.width + space
        self.webView.scrollView.contentSize = size
        self.updatePage()
    }
    
    
}

extension ReaderViewController: UIScrollViewDelegate {
   
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        self.updatePage()
    }
    
//    func scrollViewd
   
}



