//
//  ActivityTableViewCell.swift
//  LevelUp
//
//  Created by jason on 11/11/16.
//  Copyright © 2016 jasonify. All rights reserved.
//

import UIKit

class ActivityTableViewCell: UITableViewCell {

    @IBOutlet weak var activityDisplay: ActiivityView!
    @IBOutlet weak var titleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        activityDisplay.matrix = [
            [true, true, false],
            [true, false, false]
        ]
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
   
    
}
