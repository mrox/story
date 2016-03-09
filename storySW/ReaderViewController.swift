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
    
    var webView = UIWebView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        var config = WKWebViewConfiguration()
        
        self.webView = UIWebView(frame: self.view.bounds)
        self.webView.delegate = self
        self.webView.scrollView.bounces = false
        self.webView.scrollView.pagingEnabled = true
        self.webView.backgroundColor = UIColor.blueColor()
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
        
        
    }
    
    func htmlText() {
        
        let HTML = NSBundle.mainBundle().URLForResource("reader", withExtension: "html")

        do {
            var content = try NSString(contentsOfFile: (HTML?.path)!, encoding: NSUTF8StringEncoding)
            content = content.stringByReplacingOccurrencesOfString("|TITLE|", withString: self.chapter.name)
            content = content.stringByReplacingOccurrencesOfString("|CONTENT|", withString: self.chapter.content)
            
            self.webView.loadHTMLString(content as String, baseURL: HTML)
            
            print(content)
        }
        catch {
            print("error load local file")
        }
        
        
//        self.webView.loadRequest(myRequest)
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        
//        webView .stringByEvaluatingJavaScriptFromString("setTitle('abcdef');")
//        webView .stringByEvaluatingJavaScriptFromString("setContent('\(content)');")

    }

    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
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
    
    func fontDidTouch() {
        print("reload")
       //        self.webView.reload()
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
