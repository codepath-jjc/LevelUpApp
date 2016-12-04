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
            self.quests = quests.filter({ (quest: Quest) -> Bool in
                quest.archived == false
            })
            self.tableView.reloadData()
            self.refreshControl.endRefreshing()
        }) { (error: Error?) in
            // TODO: show error
            self.refreshControl.endRefreshing()
            print(error?.localizedDescription ?? "Failed Reloading Data")
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "showMilestone") {
            
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "MilestoneViewController") as! MilestoneViewController
            nextViewController.quest = selectedQuest
            self.present(nextViewController, animated:true, completion:nil)
        }
    }
}


extension ProfileViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
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
        
        if indexPath.row != 0 {
            let cell2 = cell as! QuestTableViewCell
            cell2.layoutIfNeeded()
            cell2.questHolder.addDashedBorder()
        }
        
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
            
            if (indexPath.row > 1){
                cell.isNoptCell()
            } else {
                cell.isTopCell()

            }
            return cell
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let editAction = UITableViewRowAction(style: .normal, title: "Edit") { (UITableViewRowAction, IndexPath) in
            //TODO: edit the row at indexPath here
            print("EDIT CALLED!")
        }
        editAction.backgroundColor = UIColor.blue
        
        
        let deleteAction = UITableViewRowAction(style: .normal, title: "Archive") {
            (UITableViewRowAction, IndexPath) in
            let cell = tableView.cellForRow(at: indexPath) as! QuestTableViewCell
            var quest = cell.quest
            let index = self.quests.indexOf(quest: quest)
            
            quest?.archived = true
            LevelUpClient.sharedInstance.sync(quest: &quest!, success: {
                
            }, failure: {
                (error: Error?) -> () in
                print(error?.localizedDescription ?? "Error occurred archiving quest")
            })
            self.quests.remove(at: index)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        deleteAction.backgroundColor = UIColor.red
        // http://stackoverflow.com/questions/37999727/swift-3-error-cannot-call-value-of-non-function-type-uitableview
        return [editAction,deleteAction]
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            print("DELETE")
        }
        if editingStyle == .insert {
            print("INSERT")
        }
        
        if editingStyle == .none {
            print("NONE")
        }

        // http://stackoverflow.com/questions/36315746/uitableviewrowaction-with-image-swift
        // http://swiftdeveloperblog.com/uitableviewrowaction-example-in-swift/
        // http://stackoverflow.com/questions/19164188/custom-edit-view-in-uitableviewcell-while-swipe-left-objective-c-or-swift
    }
    
}

