//
//  DetailViewController.swift
//  storySW
//
//  Created by Tran Trung Tuyen on 26/01/2016.
//  Copyright © 2016 Tran Trung Tuyen. All rights reserved.
//

import UIKit
import FormatterKit

let kButtonWidth = 40
let kStepButton = 100

class DetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var story:Story = Story()
    var full = false
    var chapters = [Chapter]()
    var numberOfButton = 0

    override func viewWillAppear(animated: Bool) {
        UIApplication.sharedApplication().setStatusBarStyle(.LightContent, animated: false)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.hidenTabbar()
        // Do any additional setup after loading the view.
//        print("story: \(story)")
        

        self.navigationItem.title = story.name
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.estimatedRowHeight = 28
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        Chapter.getList(story.sourceID) { (result) -> Void in
            self.chapters = result
            self.numberOfButton = self.chapters.count/kStepButton as Int
            self.tableView.reloadData()
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func headerView() -> UIView{
        let headerView = UIView(frame: CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 40))
        headerView.backgroundColor = UIColor.whiteColor()
        headerView.addBorder(.Bottom, color: UIColor.cloudsColor(), width: 0.5)
        
        let headerScrollView = UIScrollView(frame: CGRectMake(0, 5, CGRectGetWidth(self.view.frame), 30))
        
        headerView.addSubview(headerScrollView)
        
        
        headerScrollView.contentSize = CGSizeMake(CGFloat(self.numberOfButton * (kButtonWidth+20)), 30)
        headerScrollView.contentInset = UIEdgeInsetsMake(0, 10, 0, 10)
        headerScrollView.backgroundColor = UIColor.whiteColor()
        headerScrollView.showsHorizontalScrollIndicator = false
        
        if self.numberOfButton > 0 {
            
            for i in 0...self.numberOfButton {
                let frame = CGRectMake(CGFloat(i*(kButtonWidth+10)), 0, CGFloat(kButtonWidth), 26)
                let button = UIButton(frame: frame)
                button.backgroundColor = UIColor.carrotColor()
                button.titleLabel?.font = UIFont.boldSystemFontOfSize(12)
                button.layer.cornerRadius = CGRectGetHeight(button.frame)/2
                button.tag = i*kStepButton
                button.setTitle(i != 0 ? "\(i*kStepButton)": "1", forState: .Normal)
                button.addTarget(self, action: "scrollToChapter:", forControlEvents: .TouchUpInside)
                
                headerScrollView.addSubview(button)
            }
            
        }

        return headerView
    }
    
    func scrollToChapter(button: UIButton) {

        let indexPath = NSIndexPath.init(forItem: button.tag, inSection: 1)
        self.tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: .Top, animated: true)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2;
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1;
        }
        return self.chapters.count
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 || self.numberOfButton == 0{
            return 0;
        }
        return 40;
    }
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        if section == 0 || self.numberOfButton == 0{
            return nil
        }
//        let headerView: UIView = UIView.init(frame: CGRectMake(0, 0, self.view.frame.width, 40))
//        headerView.backgroundColor = UIColor.alizarinColor()
//        if self.numberOfButton == 0 {
//            return nil
//        }
        return self.headerView()
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var identifier = "chapterCell"
        
        if indexPath.section == 0 {
            
            identifier = "cell"
            let cell:DetailCell = tableView.dequeueReusableCellWithIdentifier(identifier, forIndexPath: indexPath) as! DetailCell
            
            cell.moreButton.addTarget(self, action: "showMore", forControlEvents: .TouchUpInside)
            
            cell.selectionStyle = .None
            cell.dataDetailCell(self.story, full: self.full)
            
            return cell
        }
        else {
            
            let cell:ChapterCell = tableView.dequeueReusableCellWithIdentifier(identifier, forIndexPath: indexPath) as! ChapterCell
            let cellData = self.chapters[indexPath.row]
            cell.nameLabel.text = "\(cellData.chapter). \(cellData.name)"
            
            //set Story post Date
            
            let dateFormatter        = NSDateFormatter()
            dateFormatter.dateFormat = "DD-MM-YY"
            
            let timeIntervalFormatter:TTTTimeIntervalFormatter    = TTTTimeIntervalFormatter()
            timeIntervalFormatter.usesIdiomaticDeicticExpressions = false
            timeIntervalFormatter.locale                          = NSLocale(localeIdentifier: "vn")
            
            cell.updateDate.text = cellData.created_at
            return cell
        }
    
    }
    
    func showMore() {
        
        self.full = !self.full;
        
        let indexPath = NSIndexPath.init(forRow: 0, inSection: 0)
        self.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if scrollView.contentOffset.y <= 0 {
            scrollView.contentOffset = CGPointZero
        }
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 0 { return }
        let chapter = self.chapters[indexPath.row]

        let detailVC: ReaderViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("readerVC") as! ReaderViewController
        
        detailVC.chapter = chapter
        self.presentViewController(detailVC, animated: true) { () -> Void in
            UIApplication.sharedApplication().setStatusBarHidden(true, withAnimation: .None)
            UIApplication.sharedApplication().setStatusBarStyle(.Default, animated: true)
        }
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
