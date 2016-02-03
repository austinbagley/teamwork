//
//  CreateTeamViewController.swift
//  ParseStarterProject-Swift
//
//  Created by Austin Bagley on 1/2/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit


class CreateTeamViewController: UIViewController {
    // MARK: Constants
    
    let SEGUE_TO_GOAL_TYPE = "showGoalType"
    
    // MARK: Properties
    
    var signup = SignUp()
    
    // MARK: Outlets
    
    @IBOutlet weak var teamName: UITextField!
    @IBOutlet weak var teamPassword: UITextField!
    @IBOutlet weak var endDate: UIDatePicker!
    @IBOutlet weak var teamChallengeName: UITextField!
    
    // MARK: View Controller lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: Actions
    
    @IBAction func createTeam(sender: UIButton) {
        let teamName = self.teamName.text!
        let teamPassword = self.teamPassword.text!
        let endDate = self.endDate.date
        let challenge = self.teamChallengeName.text!

        signup.team = signup.createTeam(teamName, teamChallengeName: challenge, teamPassword: teamPassword, endDate: endDate, callBack: {
            print("create team vc team is \(self.signup.team)")
            self.performSegueWithIdentifier("showGoalType", sender: self)
        })
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == SEGUE_TO_GOAL_TYPE {
            if let destVC = segue.destinationViewController as? GoalTypeViewController {
                destVC.team = signup.team
            }
        }
    }
}
