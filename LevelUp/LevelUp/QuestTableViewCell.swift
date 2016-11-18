//
//  QuestTableViewCell.swift
//  LevelUp
//
//  Created by jason on 11/9/16.
//  Copyright © 2016 jasonify. All rights reserved.
//

import UIKit

class QuestTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var iconImage: UIImageView!
    
    var quest:Quest! {
        didSet {
            nameLabel.text = quest.title

            LevelUpClient.sharedInstance.fetchIcon(quest: quest, success: { (image: UIImage) in
                self.iconImage.image = image
                }, failure: { (error:Error) in
                    print("---")
                    print("error", error.localizedDescription)
                    print("---")
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
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
