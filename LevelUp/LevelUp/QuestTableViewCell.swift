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
            //iconImage.image = iconImage
//            quest.fetchIcon(success: { (image: UIImage) in
//                self.iconImage.image = image
//                }, failure: { (error:Error) in
//                    
//            })
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        if let quest = quest {
//            quest.fetchIcon(success: { (image: UIImage) in
//                self.iconImage.image = image
//                }, failure: { (error:Error) in
//                    
//            })
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
