//
//  TeamSelectionViewController.swift
//  ParseStarterProject-Swift
//
//  Created by Austin Bagley on 1/2/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit

class TeamSelectionViewController: UIViewController {
    
    // MARK: Properties
    
    
    let SEGUE_TO_CREATE_TEAM = "showTeamCreation"
    let SEGUE_TO_JOIN_TEAM = "showJoinTeam"
    
    // MARK: Outlets
    
    // MARK: View Controller lifecycle
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController!.navigationBar.hidden = false
        self.navigationItem.setHidesBackButton(true, animated: false)
    }
    
    // MARK: Actions
    
    @IBAction func createTeam(sender: UIButton) {
        performSegueWithIdentifier(SEGUE_TO_CREATE_TEAM, sender: self)
    }
    
    @IBAction func joinTeam(sender: UIButton) {
        self.performSegueWithIdentifier(self.SEGUE_TO_JOIN_TEAM, sender: self)
    }
    
}
