//
//  DashboardViewController.swift
//  ParseStarterProject-Swift
//
//  Created by Austin Bagley on 1/2/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit


class DashboardViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: Constants
    
    let DASHBOARD_CELL_IDENTIFIER = "dashboardCell"
    let SEGUE_TO_WEIGHT_UPDATE = "showWeightUpdate"
    
    // MARK: Properties
    
    var goalId: String?
    var isWeightGoal: Bool?
    var teamName: String?
    var teamEndDate: NSDate?
    var userFirstName: String?
    var userGoalText: String?
    var refreshControl:UIRefreshControl!
    
    var currentUser = CurrentUser.sharedInstance

    
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
    }
    
    // MARK: Actions
    
    func refresh(sender:AnyObject){

    }
    
    @IBAction func update(sender: UIButton) {
        print(currentUser.currentGoal!.isWeightGoal!)
        if currentUser.currentGoal!.isWeightGoal! == "true" {
            performSegueWithIdentifier(self.SEGUE_TO_WEIGHT_UPDATE, sender: self)
        }
    }
    func addPullToRefresh() {
        self.refreshControl = UIRefreshControl()
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControl.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(refreshControl)
    }
    
    func updateUI() {
        challengeName.text = CurrentUser.sharedInstance.currentTeam!.teamChallengeName!
        userFullName.text = "\(CurrentUser.sharedInstance.user!.firstName!)" + " " + "\(CurrentUser.sharedInstance.user!.lastName!)"
        userGoal.text = "Lose \(String(CurrentUser.sharedInstance.currentGoal!.totalWeightLoss!)) pounds. Lost \(currentUser.currentGoal!.lostSoFar!) pounds so far."
        endDate.text = convertDate((CurrentUser.sharedInstance.currentTeam!.teamEndDate)!)
    }
    
    func convertDate(date: NSDate) -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = .LongStyle
        let dateString = dateFormatter.stringFromDate(date)
        return dateString
    }
    
    @IBAction func cancelUpdate(segue: UIStoryboardSegue) {
        self.updateUI()
    }
    
    @IBAction func finishUpdate(segue: UIStoryboardSegue) {
        self.updateUI()
        self.tableView.reloadData()
        print(self.currentUser.currentGoal?.totalWeightLoss!)
    }


    
    // MARK : Table view delegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
     
        // NEEDSWORK
    }
    
    // MARK : Table view data source
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let rows = CurrentUser.sharedInstance.teamUsers!.count
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
        
        cell!.textLabel!.text = CurrentUser.sharedInstance.teamUsers![indexPath.row].user!.firstName!
        
        let weightLoss = CurrentUser.sharedInstance.teamUsers![indexPath.row].goal!.totalWeightLoss!
        let lost = currentUser.teamUsers![indexPath.row].goal!.lostSoFar!
       
        cell!.detailTextLabel!.text = "Lose \(weightLoss) pounds." + "Lost \(lost) pounds so far."
        return cell!
    }
    
}