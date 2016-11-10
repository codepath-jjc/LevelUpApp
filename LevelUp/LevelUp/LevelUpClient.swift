//
//  LevelUpClient.swift
//  LevelUp
//
//  Created by jason on 11/10/16.
//  Copyright © 2016 jasonify. All rights reserved.
//

import UIKit

class LevelUpClient: NSObject {

    func quests(_ success: @escaping ([Quest]) ->(), failure: @escaping (Error) -> ()){
        
        
        var quests = [Quest]()
        
        let quest1 = [
            "title": "Writting",
            "image": "url"
        ]
        
        let quest2 = [
            "title": "Music",
            "image": "url"
        ]
        
        quests.append(Quest(quest1 as NSDictionary) )
        quests.append(Quest(quest2 as NSDictionary) )

        success(quests)
    }
}
