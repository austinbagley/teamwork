/**
 * Copyright (c) 2015-present, Parse, LLC.
 * All rights reserved.
 *
 * This source code is licensed under the BSD-style license found in the
 * LICENSE file in the root directory of this source tree. An additional grant
 * of patent rights can be found in the PATENTS file in the same directory.
 */

import UIKit

class RegisterViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: Properties
    
    var signUp = SignUp()
    
    let SEGUE_TO_TEAM_SELECTION = "showTeamSelection"
    
    // MARK: Outlets
    
    @IBOutlet weak var pw: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    
    // MARK: View controller lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.email.delegate = self
        self.pw.delegate = self
        self.firstName.delegate = self
        self.lastName.delegate = self
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(RegisterViewController.dismissKeyboard))
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
    
    @IBAction func registerNewUser(sender: UIButton) {
        let pw = self.pw.text!
        let email = self.email.text!
        let firstName = self.firstName.text!
        let lastName = self.lastName.text!
        
        signUp.signUpNewUser(pw, email: email, firstName: firstName, lastName: lastName, callBack: {
            self.performSegueWithIdentifier(self.SEGUE_TO_TEAM_SELECTION, sender: self)
        })
    }
    
}