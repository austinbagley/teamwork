//
//  DashboardViewController.swift
//  ParseStarterProject-Swift
//
//  Created by Austin Bagley on 1/2/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit
import Parse


class DashboardViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: Constants
    
    let DASHBOARD_CELL_IDENTIFIER = "dashboardCell"
    
    // MARK: Properties
    
    var currentUser = PFUser.currentUser()
    var currentUserId = (PFUser.currentUser()?.objectId!)!
    var teamObjectId = ""
    var teamInfo: PFObject?
    var goalType: PFObject?
    var weightGoal: PFObject?
    var goalId: String?
    var isWeightGoal: Bool?
    var teamName: String?
    var teamEndDate: NSDate?
    var userFirstName: String?
    var userGoalText: String?
    var refreshControl:UIRefreshControl!
    var userDashboard = UserDashboardData.sharedInstance

    
    // MARK: Outlets
    
    @IBOutlet weak var challengeName: UILabel!
    @IBOutlet weak var endDate: UILabel!
    @IBOutlet weak var userFullName: UILabel!
    @IBOutlet weak var userGoal: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    
    // MARK: View Controller lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControl.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(refreshControl)
      
    }
    
    // MARK: Actions
    
    func refresh(sender:AnyObject)
    {
        // put refresh code in here
        
        userDashboard.refresh(self.currentUserId, callBack: {
            self.updateUI()
            self.refreshControl.endRefreshing()
        })
    }
    
    
    func updateUI() {
        challengeName.text = userDashboard.team?.teamChallengeName!
        userFullName.text = (userDashboard.user!["firstName"] as? String)! + " " + (userDashboard.user!["lastName"] as? String)!
        userGoal.text = "Lose \(String(userDashboard.goal!.totalWeightLoss!)) pounds"
        endDate.text = convertDate((userDashboard.team?.teamEndDate)!)
    }
    
    func convertDate(date: NSDate) -> String {
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MMMM D, YYYY"
        let dateString = dateFormatter.stringFromDate(date)
        return dateString
        
    }
    
    
    // MARK : Table view delegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
     
        // NEEDSWORK
        
    }
    
    // MARK : Table view data source
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // NEEDSWORK
        
        let rows = 5
        return rows
    }
    
    // MARK : Table view Delegate
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:UITableViewCell? =
        tableView.dequeueReusableCellWithIdentifier(DASHBOARD_CELL_IDENTIFIER)! as UITableViewCell
        if (cell != nil)
        {
            cell = UITableViewCell(style: UITableViewCellStyle.Subtitle,
                reuseIdentifier: DASHBOARD_CELL_IDENTIFIER)
        }
        
        cell!.textLabel!.text = "Test Name"
        cell!.detailTextLabel!.text = "Test Goal"
        
        return cell!
    }
    

    
    
    
    
}