//
//  QuestTableViewCell.swift
//  LevelUp
//
//  Created by jason on 11/9/16.
//  Copyright © 2016 jasonify. All rights reserved.
//

import UIKit

class QuestTableViewCell: UITableViewCell {

    @IBOutlet weak var topHolderConstraint: NSLayoutConstraint!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var iconImage: UIImageView!
    
    @IBOutlet weak var questsHeaderHolder: UIView!
    @IBOutlet weak var questsHeader: UILabel!
    @IBOutlet weak var questHolder: UIView!
    var quest:Quest! {
        didSet {
            nameLabel.text = quest.title

            LevelUpClient.sharedInstance.fetchIcon(quest: quest, success: { (image: UIImage) in
                self.iconImage.image = image
                }, failure: { (error:Error) in
                    print("error", error.localizedDescription)
            })

        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        if let quest = quest {
            nameLabel.text = quest.title
            iconImage = UIImageView(image: quest.image)
        }
        
        questsHeaderHolder.backgroundColor = AppColors.BrandPrimaryBackgroundColor
        
        questsHeader.textColor = AppColors.SecondaryTextColor
     
    }

    func isTopCell() {
        questsHeader.textColor = AppColors.PrimaryTextColor
        topHolderConstraint.constant = 25
        questsHeaderHolder.isHidden = false
    }
    
    func isNoptCell(){
        topHolderConstraint.constant = 8
        questsHeaderHolder.isHidden = true

    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
}
