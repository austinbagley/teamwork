//
//  WeightGoalViewController.swift
//  ParseStarterProject-Swift
//
//  Created by Austin Bagley on 1/2/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit


class WeightGoalViewController: UIViewController, UITextFieldDelegate {
    
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
        
        self.startWeight.delegate = self
        self.goalWeight.delegate = self
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(WeightGoalViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
    }
    
    // MARK: Actions
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
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