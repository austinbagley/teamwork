//
//  LoginViewController.swift
//  ParseStarterProject-Swift
//
//  Created by Austin Bagley on 1/1/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    // MARK: Constants
    
    let SEGUE_TO_DASHBOARD = "showDashboardFromLogin"
    
    // MARK: Properties
    
    var userDashboard = UserDashboardData.sharedInstance
    
    // MARK: Outlets
    
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var pw: UITextField!
    
    // MARK: View Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

    }
    
    // MARK: Actions
    
    @IBAction func login(sender: UIButton) {
//        let username = self.username.text!
//        let pw = self.pw.text!
        
        // insert login code here
    
    }
    
    
    @IBAction func testTeam(sender: UIButton) {
        
        UpdateData().getTeamNames() {
            
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
}
