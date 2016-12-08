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
    @IBOutlet weak var activityDisplay: CalendarView!
    
    var milestone: Milestone! {
        didSet {
            // Setup the milestone info here
            dateLabel.text = ""
            numberLabel.text = ""
            categoryLabel.text = milestone.title
            if let date = milestone.deadline {
                let formatter = DateFormatter()
                formatter.dateFormat = "MMM d, yyyy"
                dateLabel.text = formatter.string(from: date)
            }
            
            mainImage.image = milestone.image ?? milestone.quest?.image
        }
    }
    
    var related: [Milestone] = [] {
        didSet {
            activityDisplay.milestones = related
            numberLabel.text = String(related.count)
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
