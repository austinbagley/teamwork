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
    let SEGUE_TO_POST = "showCreatePost"
    
    // MARK: Properties
    
    var goalId: String?
    var isWeightGoal: Bool?
    var teamName: String?
    var teamEndDate: NSDate?
    var userFirstName: String?
    var userGoalText: String?
    var currentUser = CurrentUser.sharedInstance

    
    // MARK: Outlets
    
    @IBOutlet weak var daysLeftLabel: UILabel!
    @IBOutlet weak var poundsLost: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var teamNameLabel: UILabel!
    @IBOutlet weak var userCurrentWeightLabel: UILabel!
    @IBOutlet weak var userFullName: UILabel!
    @IBOutlet weak var userGoalLabel: UILabel!
    @IBOutlet weak var userProgressView: CircleProgressView!
    
    
    // MARK: View Controller Lifecycle
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController!.navigationBar.hidden = false
        self.navigationItem.setHidesBackButton(true, animated: false)

        updateUI()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.registerNib(UINib(nibName: "DashboardCell", bundle: nil), forCellReuseIdentifier: DASHBOARD_CELL_IDENTIFIER)
    }
    
    
    // MARK: User Interactions
    
    @IBAction func logout(sender: UIBarButtonItem) {
        Login().logout() {
            self.performSegueWithIdentifier("logout", sender: self)
        }
    }
    
    @IBAction func checkIn(sender: ButtonOutline) {
        if currentUser.currentGoal!.isWeightGoal! == "true" {
            performSegueWithIdentifier(self.SEGUE_TO_WEIGHT_UPDATE, sender: self)
        }
    }
    
    @IBAction func post(sender: UIBarButtonItem) {
        performSegueWithIdentifier(SEGUE_TO_POST, sender: self)
    }
    
  
    // MARK: Helpers
    
    func updateUI() {
        
        self.tableView.rowHeight = UITableViewAutomaticDimension;
        self.tableView.estimatedRowHeight = 80.0; // set to whatever your "average" cell height is
        
        userFullName.text = "\(currentUser.user!.firstName!)" + " " + "\(currentUser.user!.lastName!)"
        userCurrentWeightLabel.text = "\(currentUser.currentGoal!.currentWeight!)"
        userGoalLabel.text = "\(String(currentUser.currentGoal!.endWeight!))"
        daysLeftLabel.text = daysToGo(currentUser.currentTeam!.teamEndDate!)
        teamNameLabel.text = currentUser.currentTeam!.teamName!
        poundsLost.text = "\(currentUser.currentGoal!.lostSoFar!)"

        let percentage: Double = Double(currentUser.currentGoal!.lostSoFar!) / Double(currentUser.currentGoal!.totalWeightLoss!)
        userProgressView.percentage = Float(percentage)

        tableView.reloadData()
        
        userProgressView.setNeedsDisplay()
        tableView.setNeedsDisplay()
        tableView.setNeedsLayout()
        
        print("Percentage completed is \(percentage)")
        print("Current weight is: \(currentUser.currentGoal!.currentWeight!)")
        
    }
    
    func convertDate(date: NSDate) -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = .LongStyle
        let dateString = dateFormatter.stringFromDate(date)
        return dateString
    }
    
    
    func daysToGo(teamEndDate: NSDate) -> String {
        let start = NSDate()
        let end = teamEndDate
        let cal = NSCalendar.currentCalendar()
        let unit: NSCalendarUnit = NSCalendarUnit.Day
        let components = cal.components(unit, fromDate: start, toDate: end, options: .MatchFirst)
        let result = "\(components.day)"
        
        return result
    }
    
    
  
    // MARK : Unwind Segues
    
    @IBAction func cancelUpdate(segue: UIStoryboardSegue) {
        self.updateUI()
    }
    
    @IBAction func finishUpdate(segue: UIStoryboardSegue) {
        self.updateUI()

    }
    
    @IBAction func savePost(segue: UIStoryboardSegue) {
        self.updateUI()
    }
    
    @IBAction func cancelPost(segue: UIStoryboardSegue) {
        self.updateUI()
    }


    // MARK : Table View Delegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
     
        // TODO :
    }
    
    // MARK : Table view data source
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let rows = CurrentUser.sharedInstance.teamUsers!.count
        return rows
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(DASHBOARD_CELL_IDENTIFIER, forIndexPath: indexPath) as! DashboardCellView
        let toGo: Int = Int(Float(currentUser.teamUsers![indexPath.row].goal!.totalWeightLoss!) - Float(currentUser.teamUsers![indexPath.row].goal!.lostSoFar!))
        
        cell.lineProgressView.percentage = Float(currentUser.teamUsers![indexPath.row].goal!.lostSoFar!) / Float(currentUser.teamUsers![indexPath.row].goal!.totalWeightLoss!)
        cell.fullName.text = "\(currentUser.teamUsers![indexPath.row].user!.firstName!) \(currentUser.teamUsers![indexPath.row].user!.lastName!)"
        cell.toGo.text = "\(toGo)"
        cell.poundsLost.text = "\(currentUser.teamUsers![indexPath.row].goal!.lostSoFar!)"
        cell.lineProgressView.setNeedsDisplay()
        
        return cell

    }
    
}