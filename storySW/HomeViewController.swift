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

class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var dataArray = [Story]()
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated);
        tableView.reloadData();
    }
    
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
        
        Alamofire.request(.GET, apiurl)
            .responseJSON { responseData in

                if (responseData.result.error != nil){
                    return
                }
                
                let swiftyJsonVar = JSON(responseData.result.value!)
                let stories = swiftyJsonVar["data"].arrayObject

                
                for subJson in stories!{
                    
                    let story : Story = Mapper<Story>().map(subJson)!
                    self.dataArray.append(story)
                    
                }
                
                self.tableView.reloadData()
                
        }
    }
    
    // MARK: - Table view data source
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell:HomeCell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! HomeCell
        
        let rowData:Story = self.dataArray[indexPath.row]
        
        cell.configCell(rowData)
        
        return cell
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
