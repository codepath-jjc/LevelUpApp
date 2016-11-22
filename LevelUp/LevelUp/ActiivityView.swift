//
//  ActiivityView.swift
//  LevelUp
//
//  Created by jason on 11/19/16.
//  Copyright © 2016 jasonify. All rights reserved.
//

import UIKit

class ActiivityView: UIView {

    var matrix = [[Bool]]() {
        didSet{
            if matrix.count > 0 {
                rows = matrix.count
                cols = matrix[0].count
            }
        }
    }
    
    var cols = 0 // 7
    var rows = 0 // 6
    
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
        // Help debug the draw rect area:
        // HELPER DEBUG
        //UIColor.white.setFill()
       // UIRectFill(rect)
        // HELPER DEBUG
        
        let green  = AppColors.PrimaryAccentColor
        let grey = AppColors.ThirdGrey
        //green.withAlphaComponent(<#T##alpha: CGFloat##CGFloat#>)
        
        let margin = CGFloat(10)
        let spacer = CGFloat(8)

        
        let marginDouble = margin *  CGFloat(2); // 10 on each
        let fullWidth =  (rect.width - marginDouble ) / CGFloat( cols);
        let fullHeight =  (rect.height - margin ) / CGFloat( rows);
        
        let height = fullHeight - spacer
        let width = fullWidth - spacer
        
        for r in 0..<rows {
            for c in 0..<cols {
                
                let x = margin +  fullWidth * CGFloat(c)
                let y = margin + fullHeight * CGFloat(r)
                let rectangle = CGRect(x: x, y: y, width: width, height: height)
                if matrix[r][c] {
                    green.setFill()
                } else {
                    grey.setFill()
                }
                UIRectFill(rectangle)
        
                
            }
        }
    }

}
