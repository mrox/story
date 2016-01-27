//
//  DetailCell.swift
//  storySW
//
//  Created by Tran Trung Tuyen on 26/01/2016.
//  Copyright © 2016 Tran Trung Tuyen. All rights reserved.
//

import UIKit

class DetailCell: UITableViewCell {

    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var cateLabel: UILabel!
    @IBOutlet weak var sourceLabel: UILabel!
    @IBOutlet weak var updateLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var moreButton: UIButton!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()

        // circle cover image
        self.coverImageView.clipsToBounds = true
        self.coverImageView.layer.cornerRadius = CGRectGetHeight(self.coverImageView.frame)/2
        
//        self.moreButton.backgroundColor = UIColor.cloudsColor()
//        self.moreButton.layer.cornerRadius = CGRectGetHeight(self.moreButton.frame)/2

    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
    /**
     set content cell
     
     - parameter story: story object
     - parameter full:  full content text
     */
    
    func dataDetailCell(story:Story, full: Bool) {
        //Justified UIlabel
        var descText = story.descriptionField
        
        if full {
            self.moreButton.setTitle("Thu Gọn", forState: .Normal)

        }
        else {
            self.moreButton.setTitle("Xem Thêm", forState: .Normal)
        }
        
        if descText.characters.count > 200 && !full {
            descText = descText.substringToIndex(descText.characters.startIndex.advancedBy(200))
        }
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = NSTextAlignment.Justified
        
        let attributedString = NSAttributedString(string: descText!,
            attributes: [
                NSParagraphStyleAttributeName: paragraphStyle,
                NSBaselineOffsetAttributeName: NSNumber(float: 0)
            ])

        
        self.nameLabel.text = story.name
//        self.descLabel.text = story.descriptionField
        self.descLabel.attributedText = attributedString
        
        self.coverImageView.kf_setImageWithURL(NSURL(string: story.imgurl)!, placeholderImage: nil, optionsInfo: [.Transition(.Fade(1))])
        
        
    }

}
