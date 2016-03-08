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
    var isWeightGoal: String?
    var teamName: String?
    var teamEndDate: NSDate?
    var userFirstName: String?
    var userGoalText: String?
    var isRegisteredToDataModel = false
    
    var teamUsers = [TeamUser]()
    
//    var currentUser = CurrentUser.sharedInstance
    
    var server = Server.sharedInstance

    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.registerNib(UINib(nibName: "DashboardCell", bundle: nil), forCellReuseIdentifier: DASHBOARD_CELL_IDENTIFIER)
        registerModelListeners()
        self.navigationController!.navigationBar.hidden = false
        self.navigationItem.setHidesBackButton(true, animated: false)

        
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
    }
    
    
    // MARK: User Interactions
    
    @IBAction func logout(sender: UIBarButtonItem) {
        Login().logout() {
            self.performSegueWithIdentifier("logout", sender: self)
        }
    }
    
    @IBAction func checkIn(sender: ButtonOutline) {
        if isWeightGoal! == "true" {
            performSegueWithIdentifier(self.SEGUE_TO_WEIGHT_UPDATE, sender: self)
        }
    }
    
    @IBAction func post(sender: UIBarButtonItem) {
        performSegueWithIdentifier(SEGUE_TO_POST, sender: self)
    }
    
  
    // MARK: Helpers
    
//    func updateUI() {
//        
//
//        
//        userFullName.text = "\(currentUser.user!.firstName!)" + " " + "\(currentUser.user!.lastName!)"
//        userCurrentWeightLabel.text = "\(currentUser.currentGoal!.currentWeight!)"
//        userGoalLabel.text = "\(String(currentUser.currentGoal!.endWeight!))"
//        print("Current end date is: \(currentUser.currentTeam!.teamEndDate)")
//        daysLeftLabel.text = "5" //daysToGo(currentUser.currentTeam!.teamEndDate!)
//        teamNameLabel.text = currentUser.currentTeam!.teamName!
//        poundsLost.text = "\(currentUser.currentGoal!.lostSoFar!)"
//
//        let percentage: Double = Double(currentUser.currentGoal!.lostSoFar!) / Double(currentUser.currentGoal!.totalWeightLoss!)
//        userProgressView.percentage = Float(percentage)
//
//        tableView.reloadData()
////        userProgressView.setNeedsDisplay()
////        tableView.setNeedsDisplay()

//        
//    }
    
    
    func registerModelListeners() {
        
        if isRegisteredToDataModel == false {
            isRegisteredToDataModel = true
            
            server.getCurrentUser() { (success, message, user) in
                if success {
                    self.onUpdateUser(success, message: message, user: user)
                    self.server.getTeamForCurrentUser(user!.currentTeam!, completion: self.onUpdateTeam)
                    self.server.getGoalForTeamForCurrentUser(user!.currentTeam!, completion: self.onUpdateGoal)
                } else {
                    self.onError(message)
                }
            }
        }
        
    }
    
    func onUpdateUser(success: Bool, message: String?, user: User?) {
        if success {
            self.userFullName.text = "\(user!.firstName!)" + " " + "\(user!.lastName!)"
        } else {
            self.onError(message)
        }
    }
    
    
    func onUpdateTeam(success: Bool, message: String?, team: Team?) {
        if success {
            //TODO: Move Days to Go to Team
            self.daysLeftLabel.text = self.daysToGo(team!.teamEndDate!)
            self.teamNameLabel.text = team!.teamName!
            self.teamUsers = team!.users!
            self.tableView.rowHeight = UITableViewAutomaticDimension;
            self.tableView.estimatedRowHeight = 80.0; // set to whatever your "average" cell height is
            self.tableView.reloadData()
            self.tableView.setNeedsLayout()
        } else {
            self.onError(message)
        }
    }
    
    
    
    func onUpdateGoal(success: Bool, message: String?, goal: Goal?) {
        if success {
            self.userCurrentWeightLabel.text = String(goal!.currentWeight!)
            self.userGoalLabel.text = String(goal!.endWeight!)
            self.poundsLost.text = String(goal!.lostSoFar!)
            
            let percentage: Double = Double(goal!.lostSoFar!) / Double(goal!.totalWeightLoss!)
            self.isWeightGoal = goal!.isWeightGoal!
            self.userProgressView.percentage = Float(percentage)
            self.userProgressView.setNeedsDisplay()
            
        } else {
            self.onError(message)
        }
    }
    
    func onError(message: String?) {
        print(message)
    }
    
    
    
    func convertDate(date: NSTimeInterval) -> String {
        let date = NSDate(timeIntervalSince1970: date)
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = .LongStyle
        let dateString = dateFormatter.stringFromDate(date)
        return dateString
    }
    
    
    func daysToGo(teamEndDate: NSTimeInterval) -> String {
        
        let start = NSDate()
        let end = NSDate(timeIntervalSince1970: teamEndDate)
        let cal = NSCalendar.currentCalendar()
        let unit: NSCalendarUnit = NSCalendarUnit.Day
        let components = cal.components(unit, fromDate: start, toDate: end, options: .MatchFirst)
        let result = "\(components.day)"
        
        return result
    }
    
    
  
    // MARK : Unwind Segues
    
    @IBAction func cancelUpdate(segue: UIStoryboardSegue) {
    }
    
    @IBAction func finishUpdate(segue: UIStoryboardSegue) {
    }
    
    @IBAction func savePost(segue: UIStoryboardSegue) {
    }
    
    @IBAction func cancelPost(segue: UIStoryboardSegue) {
    }


    // MARK: Table View Delegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
     
        // TODO :
    }
    
    // MARK: Table view data source
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return teamUsers.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(DASHBOARD_CELL_IDENTIFIER, forIndexPath: indexPath) as! DashboardCellView
        
        let toGo: Int = Int(Float(teamUsers[indexPath.row].goal!.totalWeightLoss!) - Float(teamUsers[indexPath.row].goal!.lostSoFar!))
        
        cell.lineProgressView.percentage = Float(teamUsers[indexPath.row].goal!.lostSoFar!) / Float(teamUsers[indexPath.row].goal!.totalWeightLoss!)
        cell.fullName.text = "\(teamUsers[indexPath.row].user!.firstName!) \(teamUsers[indexPath.row].user!.lastName!)"
        cell.toGo.text = "\(toGo)"
        cell.poundsLost.text = "\(teamUsers[indexPath.row].goal!.lostSoFar!)"
        cell.lineProgressView.setNeedsDisplay()
        
        return cell

    }
    
}