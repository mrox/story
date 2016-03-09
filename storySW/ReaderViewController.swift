//
//  ReaderViewController.swift
//  storySW
//
//  Created by Tran Trung Tuyen on 02/02/2016.
//  Copyright © 2016 Tran Trung Tuyen. All rights reserved.
//

import UIKit
import WebKit

class ReaderViewController: UIViewController, ControlDelegate, UIGestureRecognizerDelegate, UIWebViewDelegate {

    var scrollView: UIScrollView!
    
    var chapter = Chapter()
    var textStorage = NSTextStorage()
    var layoutManager = NSLayoutManager()
    var content = String()
    var controlView = ControlView()
    var controlIsHiden = true
    
    var paragraphView = ParagraphView()
    
    var webView = UIWebView()
    var process = false
    let prefs = NSUserDefaults.standardUserDefaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        var config = WKWebViewConfiguration()
        
        self.webView = UIWebView(frame: self.view.bounds)
        self.webView.delegate = self
        self.webView.scrollView.bounces = false
        self.webView.scrollView.pagingEnabled = true
//        self.webView.backgroundColor = UIColor.clearColor()
        self.view.addSubview(self.webView)
        
        
        Chapter.getContent(chapter.id) { (result) -> Void in
            
            self.chapter = result
            self.chapter.content = self.chapter.content.stringByReplacingOccurrencesOfString("\n", withString: "<br />")
            self.htmlText()
            
        }
        
        let tapDetect = UITapGestureRecognizer.init(target: self, action: Selector("tapGesture"))
        tapDetect.delegate = self
        self.webView.addGestureRecognizer(tapDetect)
        
        //add control view
        self.controlView = ControlView.instanceFromNib()
        self.controlView.delegate = self
        self.controlView.configView()
        self.controlView.frame = self.view.bounds
        self.controlView.alpha = 0.0
        self.view.addSubview(self.controlView)
        
        //add Paragraph View
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

        self.resizeContent()
        
    }
    
    func resizeContent(){
        if self.process {return}
        self.process = true;
        let triggerTime = (Int64(NSEC_PER_SEC) * 1)
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, triggerTime), dispatch_get_main_queue(), { () -> Void in
            
            let screenWidth = self.view.bounds.width
            var size = self.webView.scrollView.contentSize
            let space = screenWidth-(size.width % screenWidth)
            size.width =  self.webView.scrollView.contentSize.width + space
            self.webView.scrollView.contentSize = size
            self.process = false
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Touch
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
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
