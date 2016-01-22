//
//  HomeCell.swift
//  storySW
//
//  Created by Tran Trung Tuyen on 20/01/2016.
//  Copyright © 2016 Tran Trung Tuyen. All rights reserved.
//

import UIKit
import FormatterKit

class HomeCell: UITableViewCell {

    @IBOutlet weak var titleStoryLabel: UILabel!
    @IBOutlet weak var detailStoryLabel: UILabel!
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var postDate: UILabel!
    
    @IBOutlet weak var bottomCellView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // circle cover image
        self.coverImageView.clipsToBounds = true
        self.coverImageView.layer.cornerRadius = CGRectGetHeight(self.coverImageView.frame)/2
        
        //shadow cell
        
        self.bottomCellView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.1).CGColor
        self.bottomCellView.layer.shadowOffset = CGSizeMake(0.0, 2.0)
        self.bottomCellView.layer.shadowOpacity = 0.5
        self.bottomCellView.layer.shadowRadius = 0.0
        self.bottomCellView.layer.masksToBounds = false
        
    }
    
    func configCell(story:Story) {
        
        //set Story title
        
        self.titleStoryLabel.text = story.name
        
        //set Story post Date
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "DD-MM-YY"
        
        let timeIntervalFormatter:TTTTimeIntervalFormatter = TTTTimeIntervalFormatter()
        timeIntervalFormatter.usesIdiomaticDeicticExpressions = false
        timeIntervalFormatter.locale = NSLocale(localeIdentifier: "vn")
        
        self.postDate.text = timeIntervalFormatter.stringForTimeIntervalFromDate(story.updated_at, toDate: NSDate());
        
        //short Story desc
        
        let detailText = story.descriptionField
        
        let indexString = ((detailText?.characters.indexOf(".")) != nil) ? detailText?.characters.indexOf("."):detailText?.startIndex.advancedBy(200)
        
        self.detailStoryLabel.text = (detailText?.substringToIndex(indexString!))!+("...")
        
        //set cover image
        
        self.coverImageView.kf_setImageWithURL(NSURL(string: story.imgurl)!);
        
        
        //Justified UIlabel
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = NSTextAlignment.Justified
        
        let attributedString = NSAttributedString(string: self.detailStoryLabel.text!,
            attributes: [
                NSParagraphStyleAttributeName: paragraphStyle,
                NSBaselineOffsetAttributeName: NSNumber(float: 0)
            ])
        
        //set detail Story label style
        self.detailStoryLabel.attributedText = attributedString;
        
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
