//
//  SwitchTeamViewController.swift
//  teamwork
//
//  Created by Austin Bagley on 4/11/16.
//  Copyright © 2016 Austin Bagley. All rights reserved.
//

import UIKit

class SwitchTeamViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    // MARK: Properties
    
    var server = Server.sharedInstance
    let uid = Server.sharedInstance.currentUid!
    var teams = [Team]()
    let TEAM_CELL = "teamCell"
    
    // MARK: View Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSlideMenuButton()
        getTeams()
    }
    
    
    // MARK: Outlets
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: Actions
    
    func getTeams() {
        server.getTeamNamesForCurrentUser() { (success, message, teams) in
            if success {
               self.onTeamUpdate(success, message: message, teams: teams)
            } else {
                print(message)
            }
        }
    }
    
    func onTeamUpdate(success: Bool, message: String?, teams: [Team]?) {
        self.teams = teams!
        print(self.teams[0].teamName!)
        self.tableView.reloadData()
        self.tableView.setNeedsDisplay()
    }
    
    func switchCurrentTeam(team: Team) {
        server.setCurrentTeamForCurrentUser(team.id) { (success, message) in
            if success {
                self.performSegueWithIdentifier("returnToDashboard", sender: self)
            } else {
                print(message)
            }
        }
    }
    
    // MARK: Tableview Datasource
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return teams.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(TEAM_CELL, forIndexPath: indexPath) 
        cell.textLabel!.text = teams[indexPath.row].teamName
        
        return cell
    }
    
    // MARK: Tableview Delegate
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        let selectedTeam = teams[indexPath.row]
        print(selectedTeam.id!)
        switchCurrentTeam(selectedTeam)
    }
    
    
    
    
    
}
