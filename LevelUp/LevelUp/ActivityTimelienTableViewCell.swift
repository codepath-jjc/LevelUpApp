//
//  ActivityTimelienTableViewCell.swift
//  LevelUp
//
//  Created by jason on 11/28/16.
//  Copyright © 2016 jasonify. All rights reserved.
//

import UIKit

class ActivityTimelienTableViewCell: UITableViewCell {

    @IBOutlet weak var mainImage: UIImageView!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
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
