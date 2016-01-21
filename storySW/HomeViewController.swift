//
//  HomeViewController.swift
//  storySW
//
//  Created by Tran Trung Tuyen on 20/01/2016.
//  Copyright © 2016 Tran Trung Tuyen. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Kingfisher
import ObjectMapper
import FormatterKit

class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var arrRes = [[String:AnyObject]]() //Array of dictionary
    var dataArray = [Story]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNavStyle()

        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 300
        tableView.rowHeight = UITableViewAutomaticDimension
        
        self.getTableData()
    }
    
    func setNavStyle() {
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 0.31, green: 0.42, blue: 0.64, alpha: 1)
        self.navigationController?.navigationBar.translucent = false;
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getTableData() {
        let apiurl = "http://ebook2.local.192.168.1.15.xip.io/api/story"
//        let apiurl = "http://ebook2.local/api/story"
        Alamofire.request(.GET, apiurl)
            .responseJSON { responseData in
                let swiftyJsonVar = JSON(responseData.result.value!)
                let stories = swiftyJsonVar["data"].arrayObject
//                print(stories)
                for subJson in stories!{
                    let story : Story = Mapper<Story>().map(subJson)!
//                    print(story)
                    self.dataArray.append(story)
                }
                self.tableView.reloadData()
                print(self.dataArray)
                
//                if let resData = swiftyJsonVar["data"].arrayObject {
//                    self.arrRes = resData as! [[String:AnyObject]]
//                }
//                if self.arrRes.count > 0 {
//                    self.tableView.reloadData()
////                    print(self.arrRes);
//                }
        }
    }
    
    //Tableview Datasource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArray.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:HomeCell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! HomeCell
        

        let rowData:Story = self.dataArray[indexPath.row]
        
        
        cell.titleStoryLabel.text = rowData.name
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "DD-MM-YY"
        
        let date = rowData.updated_at.timeIntervalSinceNow
        print(date);
        

        let timeIntervalFormatter:TTTTimeIntervalFormatter = TTTTimeIntervalFormatter()

        cell.postDate.text = timeIntervalFormatter.stringForTimeIntervalFromDate(rowData.updated_at, toDate: NSDate());

        
        
        let detailText = rowData.descriptionField
        
        let indexString = ((detailText?.characters.indexOf(".")) != nil) ? detailText?.characters.indexOf("."):detailText?.startIndex.advancedBy(200)
        
        cell.detailStoryLabel.text = (detailText?.substringToIndex(indexString!))!+("...")
        
        cell.coverImageView.kf_setImageWithURL(NSURL(string: rowData.imgurl)!);
        
        
        //Justified UIlabel
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = NSTextAlignment.Justified
        
        let attributedString = NSAttributedString(string: cell.detailStoryLabel.text!,
            attributes: [
                NSParagraphStyleAttributeName: paragraphStyle,
                NSBaselineOffsetAttributeName: NSNumber(float: 0)
            ])
        cell.detailStoryLabel.attributedText = attributedString;
        
//        let rowData = self.arrRes[indexPath.row]
//        
//    
//        cell.titleStoryLabel.text = rowData["name"] as? String
//        
//        let detailText = rowData["description"] as? String
//        let indexString = ((detailText?.characters.indexOf(".")) != nil) ? detailText?.characters.indexOf("."):detailText?.startIndex.advancedBy(200)
//        
//        cell.detailStoryLabel.text = (detailText?.substringToIndex(indexString!))!+("...")
//        
//        cell.coverImageView.kf_setImageWithURL(NSURL(string: (rowData["imgurl"] as? String)!)!);
//        
//        
//        //Justified UIlabel
//        
//        let paragraphStyle = NSMutableParagraphStyle()
//        paragraphStyle.alignment = NSTextAlignment.Justified
//        
//        let attributedString = NSAttributedString(string: cell.detailStoryLabel.text!,
//            attributes: [
//                NSParagraphStyleAttributeName: paragraphStyle,
//                NSBaselineOffsetAttributeName: NSNumber(float: 0)
//            ])
//        cell.detailStoryLabel.attributedText = attributedString;
        
        return cell
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated);
        tableView.reloadData();
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
