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
    
    var login = Login()
        
    // MARK: Outlets
    
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var pw: UITextField!
    
    // MARK: View Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

    }
    
    // MARK: Actions
    
    @IBAction func login(sender: UIButton) {
        let username = self.username.text!
        let pw = self.pw.text!
        
        login.login(username, pw: pw) {
            self.performSegueWithIdentifier(self.SEGUE_TO_DASHBOARD, sender: self)
        }
    
    }
    
    
    @IBAction func testTeam(sender: UIButton) {
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
}
