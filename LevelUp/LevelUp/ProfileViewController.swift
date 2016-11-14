//
//  ProfileViewController.swift
//  LevelUp
//
//  Created by jason on 11/9/16.
//  Copyright © 2016 jasonify. All rights reserved.
//

import UIKit

import Parse

class ProfileViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var navigationDelegate: TabBarViewController?
    var quests = [Quest]()
    
    let refreshControl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.estimatedRowHeight = 120
        tableView.rowHeight = UITableViewAutomaticDimension
        
        
        refreshControl.addTarget(self, action: #selector(ProfileViewController.refreshControlAction(refreshControl:)), for: UIControlEvents.valueChanged)
        // add refresh control to table view
        tableView.insertSubview(refreshControl, at: 0)
        
        
        reloadData()
    }
    
    
    func refreshControlAction(refreshControl: UIRefreshControl) {
        self.reloadData()
    }
    
    func reloadData() {
        
         Quest.all({ (quests:[Quest]) in
        
                print(quests)
        //LevelUpClient.sharedInstance.quests({ (quests:[Quest]) in
            // In the event this VC has a quest loaded already
            self.quests = quests
            self.tableView.reloadData()
            self.refreshControl.endRefreshing()

        }) { (error:Error) in
            // TODO: show error
            self.refreshControl.endRefreshing()
            
        }
        
    }
    
}


extension ProfileViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return quests.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = Bundle.main.loadNibNamed("ActivityTableViewCell", owner: self, options: nil)?.first  as! ActivityTableViewCell
            return cell
        } else {
            let cell = Bundle.main.loadNibNamed("QuestTableViewCell", owner: self, options: nil)?.first  as! QuestTableViewCell
            
            cell.quest = quests[indexPath.row-1]
            return cell
            
        }
        
    }
    
}

