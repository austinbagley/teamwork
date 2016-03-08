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
    var teamList = [Team]()
    
    var server = Server.sharedInstance
    
    // MARK: Constants
    
    let SEGUE_TO_GOAL_SELECTION = "segueToGoalTypeFromJoin"
    
    // MARK: Outlets
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: View Controller lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController!.navigationBar.hidden = false
        getTeamNames()
    }
    
    // MARK: Actions
    
    func getTeamNames() {
        server.getTeamNames() { (success, message, teams) in
            if success {
                self.teamList = teams!
                self.tableView.reloadData()
                self.tableView.setNeedsDisplay()
            } else {
                print(message)
            }
        }
    }
    
    
    // MARK: Table View Data Source
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
        let cells = self.teamList.count
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
        
        
        cell!.textLabel!.text = teamList[indexPath.row].teamName!
        cell!.detailTextLabel!.text = teamList[indexPath.row].teamChallengeName!
        return cell!
    }
    
    
    
    // MARK: Table View Delegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var team: Team?
        let position = indexPath.row

        team = teamList[position]
        let teamId = team!.id!

        self.server.addTeamToCurrentUser(teamId) { (success, message) in
            if success {
                self.performSegueWithIdentifier(self.SEGUE_TO_GOAL_SELECTION, sender: self)
            } else {
                print(message)
            }
        }
    }

    
}