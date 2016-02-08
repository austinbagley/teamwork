//
//  WeightGoalViewController.swift
//  ParseStarterProject-Swift
//
//  Created by Austin Bagley on 1/2/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit


class WeightGoalViewController: UIViewController {
    
    // MARK: Constants
    
    let SEGUE_TO_DASHBOARD = "showDashboard"

    // MARK: Properties
    
    var signUp = SignUp()
    var team: Team?
    var goal: Goal?
    
    // MARK: Outlets
    
    @IBOutlet weak var startWeight: UITextField!
    @IBOutlet weak var goalWeight: UITextField!
    
    // MARK: View Controller lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let team = CurrentUser.sharedInstance.currentTeam
        signUp.getUserList(team) {
            // any call back here
        }
        
    }
    
    // MARK: Actions
    
    @IBAction func done(sender: UIButton) {
        let startWeight = Double(self.startWeight.text!)!
        let goalWeight = Double(self.goalWeight.text!)!
        let currentTeam = CurrentUser.sharedInstance.currentTeam!
        
        signUp.createWeightGoalFromSignup(startWeight, endWeight: goalWeight, callBack: ({
            let teamList = CurrentUser.sharedInstance.teamList
            
            self.signUp.populateTeamData(teamList!, team: currentTeam) {
                self.performSegueWithIdentifier(self.SEGUE_TO_DASHBOARD, sender: self)
            }
        }))

    }
}