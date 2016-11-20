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
        // Clear the background otherwise it is black
        self.backgroundColor = UIColor.clear
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        //initSubviews()
        // Clear the background otherwise it is black
        self.backgroundColor = UIColor.clear
    }
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
 
        let green  = AppColors.PrimaryAccentColor
        
        let margin = CGFloat(10)
        let spacer = CGFloat(8)

        
        let marginDouble = margin *  CGFloat(2); // 10 on each
        let fullWidth =  (rect.width - marginDouble ) / CGFloat( cols);
        let fullHeight =  (rect.height - marginDouble ) / CGFloat( cols);
        
        let height = fullHeight - spacer
        let width = fullWidth - spacer
        
        for r in 0...rows-1 {
            for c in 0...cols-1 {
                
                let x = margin +  fullWidth * CGFloat(c)
                let y = fullHeight * CGFloat(r)
                let rectangle = CGRect(x: x, y: y, width: width, height: height)
                green.setFill()
                UIRectFill(rectangle)
        
                
            }
        }
        
        
    }

}
