//
//  CalendarView.swift
//  LevelUp
//
//  Created by Claudiu Andrei on 12/1/16.
//  Copyright © 2016 jasonify. All rights reserved.
//

import UIKit

enum CalendarStates {
    case completed, pending, overdue, today, empty
}

class CalendarView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    var milestones = [Milestone]() {
        didSet{
            // Compute the matrix from the milestone dates
        }
    }
    
    var cols = 0
    var rows = 0
    var matrix: [[CalendarStates]] = []
    
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
        let grey = AppColors.ThirdGrey
        
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
                
                // Need to have multiple styles here
                switch matrix[r][c] {
                case .completed, .overdue, .pending, .today:
                    green.setFill()
                case .empty:
                    grey.setFill()
                }
                UIRectFill(rectangle)
                
                
            }
        }
    }
    
}
