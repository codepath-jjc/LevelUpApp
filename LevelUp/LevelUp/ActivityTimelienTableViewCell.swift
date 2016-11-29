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
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
