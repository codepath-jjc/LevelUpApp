//
//  ActiivityView.swift
//  LevelUp
//
//  Created by jason on 11/19/16.
//  Copyright © 2016 jasonify. All rights reserved.
//

import UIKit

class ActiivityView: UIView {

    
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
 
        
        // Get the Graphics Context
        var path = UIBezierPath(ovalIn: rect)
        UIColor.green.setFill()
        path.fill()
    }

}
