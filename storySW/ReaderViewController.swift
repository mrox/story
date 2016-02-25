//
//  ReaderViewController.swift
//  storySW
//
//  Created by Tran Trung Tuyen on 02/02/2016.
//  Copyright © 2016 Tran Trung Tuyen. All rights reserved.
//

import UIKit


class ReaderViewController: UIViewController, ControlDelegate, UIGestureRecognizerDelegate {

    var scrollView: UIScrollView!
    
    var chapter = Chapter()
    var textStorage = NSTextStorage()
    var layoutManager = NSLayoutManager()
    var content = NSMutableAttributedString()
    var controlView = ControlView()
    var controlIsHiden = true
    
    var webView = UIWebView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.webView = UIWebView.init(frame: self.view.bounds)
        self.view.addSubview(self.webView)
        
        
        Chapter.getContent(chapter.id) { (result) -> Void in
            print(result)
            self.content = NSMutableAttributedString.init(string: result.content)
            
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
        var HTML = NSBundle.mainBundle().URLForResource("reader", withExtension: "html")
        let myRequest = NSURLRequest(URL: HTML!);
        self.webView.loadRequest(myRequest)
//
//        let HTMLDocumentPath = NSBundle.mainBundle().pathForResource("reader", ofType: "html")
//        let HTMLString: NSString?
//        
//        do {
//            HTMLString = try NSString(contentsOfFile: HTMLDocumentPath!, encoding: NSUTF8StringEncoding)
//        } catch {
//            HTMLString = nil
//        }
//        
//        self.webView.loadHTMLString(HTMLString as! String, baseURL: nil)
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


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
