/**
 * Copyright (c) 2015-present, Parse, LLC.
 * All rights reserved.
 *
 * This source code is licensed under the BSD-style license found in the
 * LICENSE file in the root directory of this source tree. An additional grant
 * of patent rights can be found in the PATENTS file in the same directory.
 */

import UIKit
import Parse

class RegisterViewController: UIViewController {
    
    // MARK: Properties
    
    var signUp = SignUp()
    
    // MARK: Outlets
    
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var pw: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    
    
    
    
    
    // MARK: View controller lifecycle
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    
    // MARK: Actions
    
    @IBAction func registerNewUser(sender: UIButton) {
        let pw = self.pw.text!
        let email = self.email.text!
        let firstName = self.firstName.text!
        let lastName = self.lastName.text!
        
        signUp.signUpNewUser(pw, email: email, firstName: firstName, lastName: lastName, callBack: {
            self.performSegueWithIdentifier("showTeamSelection", sender: self)
        })
        
        
    }
    
    
    
    
}