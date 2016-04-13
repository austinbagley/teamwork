//
//  CreateTeamViewController.swift
//  ParseStarterProject-Swift
//
//  Created by Austin Bagley on 1/2/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit


class CreateTeamViewController: UIViewController, UITextFieldDelegate {
    // MARK: Constants
    
    let SEGUE_TO_GOAL_TYPE = "showGoalType"
    let SEGUE_TO_WEIGHT = "straightToWeight"

    
    // MARK: Properties
    
    var server = Server.sharedInstance
    
    // MARK: Outlets
    
    @IBOutlet weak var teamName: UITextField!
    @IBOutlet weak var teamPassword: UITextField!
    @IBOutlet weak var endDate: UIDatePicker!
    @IBOutlet weak var teamChallengeName: UITextField!
    
    // MARK: View Controller lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.teamName.delegate = self
        self.teamPassword.delegate = self
        self.teamChallengeName.delegate = self
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(CreateTeamViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        self.navigationController!.navigationBar.hidden = false

    }
    
    // MARK: Actions
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if let nextField = view.viewWithTag(textField.tag + 1) {
            nextField.becomeFirstResponder()
        }
        return true
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func createTeam(sender: UIButton) {
        let teamName = self.teamName.text!
        let teamPassword = self.teamPassword.text!
        let endDate = self.endDate.date
        let challenge = self.teamChallengeName.text!
        
        server.createAndAddUserToTeam(teamName, teamChallengeName: challenge, teamPassword: teamPassword, endDate: endDate) { (success: Bool, message: String?) in
            if success {
                self.performSegueWithIdentifier(self.SEGUE_TO_WEIGHT, sender: self)
            } else {
                print(message)
            }
        }
    }
    
}
