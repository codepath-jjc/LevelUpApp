//
//  ActivityTimelineViewController.swift
//  LevelUp
//
//  Created by Joshua Escribano on 11/12/16.
//  Copyright © 2016 jasonify. All rights reserved.
//

import UIKit

class ActivityTimelineViewController: UIViewController {
    var navigationDelegate: TabBarViewController?

    var _milestones = [Milestone]()
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 120
        tableView.rowHeight = UITableViewAutomaticDimension
        // Do any additional setup after loading the view.
        reloadData()
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func reloadData() {
        
    /*    LevelUpClient.sharedInstance.quests(success: { (quests:[Quest]) in
            // In the event this VC has a quest loaded already
            self.quests = quests
            self.tableView.reloadData()
            self.refreshControl.endRefreshing()
        }) { (error: Error?) in
            // TODO: show error
            self.refreshControl.endRefreshing()
        }
        
 
 */
        
        LevelUpClient.sharedInstance.milestones(success: { (milestones: [Milestone]) in
            
            self._milestones = milestones
            self.tableView.reloadData()
            
        }) { (error:Error?) in
            
        }
    }

    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}



extension ActivityTimelineViewController: UITableViewDataSource, UITableViewDelegate {
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self._milestones.count
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
 
        let cell = Bundle.main.loadNibNamed("ActivityTimelienTableViewCell", owner: self, options: nil)?.first  as! ActivityTimelienTableViewCell
            
       
        var milestone = _milestones[indexPath.row]
        cell.categoryLabel.text = milestone.title
        cell.numberLabel.text = "#\(indexPath.row+1)"
        return cell
        
        
    }
    
   

}
