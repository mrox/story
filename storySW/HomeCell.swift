//
//  HomeCell.swift
//  storySW
//
//  Created by Tran Trung Tuyen on 20/01/2016.
//  Copyright © 2016 Tran Trung Tuyen. All rights reserved.
//

import UIKit

class HomeCell: UITableViewCell {

    @IBOutlet weak var titleStoryLabel: UILabel!
    @IBOutlet weak var detailStoryLabel: UILabel!
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var postDate: UILabel!
    
    @IBOutlet weak var bottomCellView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.coverImageView.clipsToBounds = true
        self.coverImageView.layer.cornerRadius = CGRectGetHeight(self.coverImageView.frame)/2
        
        self.bottomCellView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.1).CGColor
        self.bottomCellView.layer.shadowOffset = CGSizeMake(0.0, 2.0)
        self.bottomCellView.layer.shadowOpacity = 0.5
        self.bottomCellView.layer.shadowRadius = 0.0
        self.bottomCellView.layer.masksToBounds = false
//        self.bottomCellView.layer.cornerRadius = 4.0
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
