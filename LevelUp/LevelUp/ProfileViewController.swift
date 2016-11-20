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
    var selectedQuest:Quest?
    
    let refreshControl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.estimatedRowHeight = 120
        tableView.rowHeight = UITableViewAutomaticDimension
        
        refreshControl.addTarget(self, action: #selector(ProfileViewController.refreshControlAction(refreshControl:)), for: UIControlEvents.valueChanged)
        // Add refresh control to table view
        tableView.insertSubview(refreshControl, at: 0)
        
        self.tableView.backgroundColor =  AppColors.BrandPrimaryBackgroundColor
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.none

        reloadData()
    }
    
    
    func refreshControlAction(refreshControl: UIRefreshControl) {
        self.reloadData()
    }
    
    func reloadData() {
        
        LevelUpClient.sharedInstance.quests(success: { (quests:[Quest]) in
            // In the event this VC has a quest loaded already
            self.quests = quests
            self.tableView.reloadData()
            self.refreshControl.endRefreshing()
        }) { (error: Error?) in
            // TODO: show error
            self.refreshControl.endRefreshing()
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "showMilestone") {
            
           // let navigationController = segue.destination as! UINavigationController
            
          // let tweetDetailsVieController = navigationController.topViewController as! TweetDetailViewController
          // tweetDetailsVieController.tweet  = selectedTweet
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "MilestoneViewController") as! MilestoneViewController
            nextViewController.quest = selectedQuest
            self.present(nextViewController, animated:true, completion:nil)
    
        
        }
    }
}


extension ProfileViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row > 0 {
            selectedQuest = quests[indexPath.row-1]
            performSegue(withIdentifier: "showMilestone", sender: self)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return quests.count + 1
    }
    
  
        // TRYING TO MAKE ROW FULL WIDTH???
    override func viewDidLayoutSubviews() {
        
        self.tableView.separatorInset = UIEdgeInsets.zero
        self.tableView.layoutMargins = UIEdgeInsets.zero
    }
    

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        
        if indexPath.row == 0 {
        } else {
            let cell2 = cell as! QuestTableViewCell
            cell2.layoutIfNeeded()
            cell2.questHolder.addDashedBorder()
        }
            
        // cell.separatorInset = UIEdgeInsets.zero
        // cell.layoutMargins = UIEdgeInsets.zero
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = Bundle.main.loadNibNamed("ActivityTableViewCell", owner: self, options: nil)?.first  as! ActivityTableViewCell
            cell.backgroundColor = AppColors.BrandPrimaryBackgroundColor
            cell.titleLabel.textColor = AppColors.PrimaryTextColor
            return cell
        } else {
            let cell = Bundle.main.loadNibNamed("QuestTableViewCell", owner: self, options: nil)?.first  as! QuestTableViewCell
            
            cell.quest = quests[indexPath.row-1]
            cell.nameLabel.textColor =  AppColors.SecondaryTextColor
            cell.iconImage.layer.masksToBounds = true
            cell.iconImage.layer.cornerRadius = 10
            cell.backgroundColor = AppColors.BrandPrimaryBackgroundColor
            
            if (indexPath.row > 1){
                cell.isNoptCell()
            } else {
                cell.isTopCell()

            }
            return cell
            
        }
        
    }
    
}

