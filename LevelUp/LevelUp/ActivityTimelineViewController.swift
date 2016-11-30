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
    let refreshControl = UIRefreshControl()
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
        
        tableView.backgroundColor = AppColors.BrandPrimaryBackgroundColor
        refreshControl.addTarget(self, action: #selector(ActivityTimelineViewController.refreshControlAction(refreshControl:)), for: UIControlEvents.valueChanged)
        // Add refresh control to table view
        tableView.insertSubview(refreshControl, at: 0)
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.none

        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func refreshControlAction(refreshControl: UIRefreshControl) {
        self.reloadData()
    }
    
    
    
    func reloadData() {

        

        LevelUpClient.sharedInstance.milestones(success: { (milestones: [Milestone]) in
         
            // TODO: JASON add back            
            //self._milestones = milestones
            self.refreshControl.endRefreshing()
            self.tableView.reloadData()


        }) { (error:Error?) in
            self.refreshControl.endRefreshing()
            self.tableView.reloadData()


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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       // return self._milestones.count
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
 
        let cell = Bundle.main.loadNibNamed("ActivityTimelienTableViewCell", owner: self, options: nil)?.first  as! ActivityTimelienTableViewCell
            
       
        //let milestone = _milestones[indexPath.row]
        cell.milestone = Milestone.init(dictionary: ["title": "Music"])
        return cell
    }
    
   

}
