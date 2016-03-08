//
//  LoginViewController.swift
//  ParseStarterProject-Swift
//
//  Created by Austin Bagley on 1/1/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    
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
        
        self.username.delegate = self
        self.pw.delegate = self
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    // MARK: Actions
    
    @IBAction func logout(segue: UIStoryboardSegue) {
        
    }

    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
   
    
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
