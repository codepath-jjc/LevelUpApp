//
//  Frequency.swift
//  LevelUp
//
//  Created by Joshua Escribano on 11/28/16.
//  Copyright © 2016 jasonify. All rights reserved.
//

import Foundation

enum Frequency: Int {
    case daily, weekly
    
    func simpleDescription() -> String {
        switch self {
        case .daily:
            return "Daily"
        case .weekly:
            return "Weekly"
        }
    }
}
