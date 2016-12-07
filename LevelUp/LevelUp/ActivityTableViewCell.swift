//
//  ActivityTableViewCell.swift
//  LevelUp
//
//  Created by jason on 11/11/16.
//  Copyright © 2016 jasonify. All rights reserved.
//

import UIKit

class ActivityTableViewCell: UITableViewCell {

    @IBOutlet weak var activityDisplay: CalendarView!
    @IBOutlet weak var titleLabel: UILabel!
    
    var milestones: [Milestone] = [] {
        didSet {
            activityDisplay.milestones = milestones
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
   
    
}
