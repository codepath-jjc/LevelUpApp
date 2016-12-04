//
//  ActivityTimelienTableViewCell.swift
//  LevelUp
//
//  Created by jason on 11/28/16.
//  Copyright © 2016 jasonify. All rights reserved.
//

import UIKit

class ActivityTimelineTableViewCell: UITableViewCell {

    @IBOutlet weak var mainImage: UIImageView!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var activityDisplay: ActiivityView!
    
    var milestone: Milestone! {
        didSet {
            // Setup the milestone info here
            categoryLabel.text = milestone.title
            numberLabel.text = "1"
            mainImage.image = #imageLiteral(resourceName: "placeholder").setAlpha(value: 0.12)
            
            activityDisplay.matrix = [
                [true, true, false, true, true, true, true],
                [true, false, false, true, true, false, true],
                [true, false, false, true, false, false, false],
                [true, false, false, false, true, false, true]
            ]
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.backgroundColor = AppColors.BrandPrimaryBackgroundColor
        
        categoryLabel.textColor = AppColors.PrimaryTextColor
        dateLabel.textColor = AppColors.PrimaryTextColor
        numberLabel.textColor = AppColors.PrimaryTextColor
        
        mainImage.layer.cornerRadius = 20.0
        mainImage.clipsToBounds = true
        
        //viewHolder.backgroundColor = AppColors.BrandPrimaryBackgroundColor

        //mainImage.image.setAlpha(CGFloat(0.4))
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension UIImage{
    
    func setAlpha(value:CGFloat)->UIImage
    {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        draw(at: CGPoint.zero, blendMode: .normal, alpha: value)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
        
    }
}
