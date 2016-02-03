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
    let SEGUE_TO_JOIN_TEAM = "showTeamJoin"
    
    // MARK: Outlets
    
    // MARK: View Controller lifecycle
    
    // MARK: Actions
    
    @IBAction func createTeam(sender: UIButton) {
        performSegueWithIdentifier(SEGUE_TO_CREATE_TEAM, sender: self)
    }
    
    @IBAction func joinTeam(sender: UIButton) {
        performSegueWithIdentifier(SEGUE_TO_JOIN_TEAM, sender: self)
    }
    
  
}
