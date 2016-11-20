//
//  ActiivityView.swift
//  LevelUp
//
//  Created by jason on 11/19/16.
//  Copyright © 2016 jasonify. All rights reserved.
//

import UIKit

class ActiivityView: UIView {

    
    var cols = 7
    var height = 6
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //initSubviews()
    self.backgroundColor = UIColor.clear
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        //initSubviews()
    self.backgroundColor = UIColor.clear
    }
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
 
        let green  = AppColors.PrimaryAccentColor
        
        let rectangle = CGRect(x: 0, y: 0, width: 10, height: 10.0)
        green.setFill()
        UIRectFill(rectangle)
        
        let rectangle2 = CGRect(x: 20, y: 0, width: 10, height: 10.0)
        green.setFill()
        UIRectFill(rectangle2)
        
    }

}
