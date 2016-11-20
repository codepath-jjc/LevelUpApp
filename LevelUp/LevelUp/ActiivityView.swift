//
//  ActiivityView.swift
//  LevelUp
//
//  Created by jason on 11/19/16.
//  Copyright © 2016 jasonify. All rights reserved.
//

import UIKit

class ActiivityView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    override func draw(_ rect: CGRect) {
        
        // Get the Graphics Context
        var path = UIBezierPath(ovalIn: rect)
        UIColor.green.setFill()
        path.fill()
    }

}
