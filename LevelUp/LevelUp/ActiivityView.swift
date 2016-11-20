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
    var rows = 6
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
        
        
        
        var remainingWidth = CGFloat(20); // 10 on each
        var fullWidth =  (rect.width - remainingWidth ) / CGFloat( cols);
        
        var height = CGFloat(20);
        var fullHeight = height + CGFloat(3)
        var width = fullWidth - CGFloat(3)
        
        for r in 0...rows {
            for c in 0...cols {
                
                let x = fullWidth * CGFloat(c)
                let y = fullHeight * CGFloat(r)
                let rectangle = CGRect(x: x, y: y, width: width, height: height)
                green.setFill()
                UIRectFill(rectangle)
        
                
            }
        }
        
        
    }

}
