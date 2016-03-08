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
    
    let server = Server.sharedInstance
    
    // MARK: Outlets
    
    @IBOutlet weak var startWeight: UITextField!
    @IBOutlet weak var goalWeight: UITextField!
    
    // MARK: View Controller lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.startWeight.delegate = self
        self.goalWeight.delegate = self
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(WeightGoalViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
    }
    
    // MARK: Actions
    
    @IBAction func done(sender: UIButton) {
        let startWeight = Double(self.startWeight.text!)!
        let goalWeight = Double(self.goalWeight.text!)!
        
        server.createWeightGoalForCurrentUser(startWeight, endWeight: goalWeight) { (success, message) in
            if success {
               self.performSegueWithIdentifier(self.SEGUE_TO_DASHBOARD, sender: self)
            } else {
                print(message)
            }
        }
    }
    
    // MARK: Helpers
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
}