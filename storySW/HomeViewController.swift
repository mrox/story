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

    var dataArray   = NSMutableArray()
    var currentPage = 1
    var loading     = false

	override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated) ;
		tableView.reloadData() ;
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		self.setNavStyle()

        tableView.dataSource         = self
        tableView.delegate           = self
        tableView.estimatedRowHeight = 300
        tableView.rowHeight          = UITableViewAutomaticDimension

		self.getTableData(currentPage)
	}

	func setNavStyle() {
        self.navigationController?.navigationBar.barTintColor        = UIColor(red: 0.31, green: 0.42, blue: 0.64, alpha: 1)
        self.navigationController?.navigationBar.translucent         = false;
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        self.navigationController?.navigationBar.tintColor           = UIColor.whiteColor()

        let logo : UIImage            = UIImage.init(named: "home_logo")!
        self.navigationItem.titleView = UIImageView.init(image: logo)
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	func getTableData(page: Int) {

		loading = true

		dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {

			Story.getNew(page: page) { (result) -> Void in

				dispatch_async(dispatch_get_main_queue()) {
					self.loading = false
					self.dataArray.addObjectsFromArray(result)
					self.tableView.reloadData()
				}
			}
		}
	}

	// MARK: - Table view data source

	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.dataArray.count
	}

	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let cell: HomeCell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! HomeCell

        let rowData: Story = self.dataArray[indexPath.row] as! Story

		cell.configCell(rowData)

		cell.lastChapterButton.tag = indexPath.row

		cell.lastChapterButton.addTarget(self, action: "lastChapterClick:", forControlEvents: .TouchUpInside)

		return cell
	}

	func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {

		// load more
		if (self.dataArray.count - 5 == indexPath.row && !self.loading) {
			self.currentPage++
			getTableData(self.currentPage)
		}
	}

	func lastChapterClick(sender: UIButton) {
		let story: Story = self.dataArray[sender.tag] as! Story
		print(story)
	}

	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

        let detailVC: DetailViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("detailVC") as! DetailViewController
        
        detailVC.hidesBottomBarWhenPushed  = true
        detailVC.story                     = self.dataArray[indexPath.row] as! Story
        
		self.navigationController?.pushViewController(detailVC, animated: true)
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
