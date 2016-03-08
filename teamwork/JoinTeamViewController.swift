//
//  JoinTeamViewController.swift
//  ParseStarterProject-Swift
//
//  Created by Austin Bagley on 1/2/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit


class JoinTeamViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: Properties
    
    var user: User?
    var teams: [String]?
    var teamList: [Team]?
    
    
    let SEGUE_TO_GOAL_SELECTION = "segueToGoalTypeFromJoin"
    
    
    // MARK: Outlets
    
    @IBOutlet weak var tableView: UITableView!
    
    
    // MARK: View Controller lifecycle
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController!.navigationBar.hidden = false
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.setNeedsDisplay()
    }
    
    // MARK: Actions
    
    // Build Team Names Array
    
    
    // MARK: Table View Data Source
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
        let cells = self.teamList!.count
        return cells
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell:UITableViewCell? =
        tableView.dequeueReusableCellWithIdentifier("teamCell")! as UITableViewCell
        if (cell != nil)
        {
            cell = UITableViewCell(style: UITableViewCellStyle.Subtitle,
                reuseIdentifier: "teamCell")
        }
        
        
        cell!.textLabel!.text = teamList![indexPath.row].teamName!
        cell!.detailTextLabel!.text = teamList![indexPath.row].teamChallengeName!
        return cell!
    }
    
    
    
    // MARK: Table View Delegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var team: Team?
        let position = indexPath.row
        
        team = teamList![position]
        
        print("We're sending along this team \(team!.id!)")
        
        CurrentUser.sharedInstance.user!.currentTeam = team!.id!
        CurrentUser.sharedInstance.currentTeam = team!
        
        
        
        SignUp().updateTeamandUser(team!, callBack: {
            self.performSegueWithIdentifier(self.SEGUE_TO_GOAL_SELECTION, sender: self)
        })
    }

    
}