//
//  LoginViewController.swift
//  ParseStarterProject-Swift
//
//  Created by Austin Bagley on 1/1/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController {
    
    // MARK: Constants
    
    let SEGUE_TO_DASHBOARD = "showDashboardFromLogin"
    
    // MARK: Properties
    
    var currentUser = PFUser.currentUser()
    var userDashboard = UserDashboardData.sharedInstance
    
    // MARK: Outlets
    
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var pw: UITextField!
    
    // MARK: View Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

//     Segue past Login if Current User isn't nil
        print("current user is \(currentUser)")
        
        if currentUser != nil {
            self.userDashboard.refresh(PFUser.currentUser()!.objectId!, callBack: {
            self.performSegueWithIdentifier(self.SEGUE_TO_DASHBOARD, sender: self)
            })
        } else {
            // DO Nothing
        }
    }
    
    // MARK: Actions
    
    @IBAction func login(sender: UIButton) {
        let username = self.username.text!
        let pw = self.pw.text!
        
        PFUser.logInWithUsernameInBackground(username, password: pw) {
            (user: PFUser?, error: NSError?) -> Void in
            
            if user != nil {
                print("user logged in as \(PFUser.currentUser()!)")
                self.userDashboard.refresh(PFUser.currentUser()!.objectId!, callBack: {
                    self.performSegueWithIdentifier(self.SEGUE_TO_DASHBOARD, sender: self)
                })
            } else {
                print("login failed")
                print(error)
            }
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
