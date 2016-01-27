//
//  DetailViewController.swift
//  storySW
//
//  Created by Tran Trung Tuyen on 26/01/2016.
//  Copyright © 2016 Tran Trung Tuyen. All rights reserved.
//

import UIKit



class DetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var story:Story = Story()
    var full = false
    var chapters = [Chapter]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        print("story: \(story)")
        

        self.navigationItem.title = story.name
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.estimatedRowHeight = 30
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        Chapter.getList(story.id) { (result) -> Void in
            self.chapters = result
            self.tableView.reloadData()
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        if section == 0 {
            return 0;
        }
        return 40;
    }
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        print("change header view")
        if section == 0 {
            return nil
        }
        let headerView: UIView = UIView.init(frame: CGRectMake(0, 0, self.view.frame.width, 40))
        headerView.backgroundColor = UIColor.alizarinColor()
        
        return headerView
        
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
            let cell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier(identifier, forIndexPath: indexPath)
            let cellData = self.chapters[indexPath.row]
            cell.textLabel?.text = "\(cellData.chapter). \(cellData.name)"
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
