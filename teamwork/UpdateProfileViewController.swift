//
//  UpdateProfileViewController.swift
//  teamwork
//
//  Created by Austin Bagley on 4/11/16.
//  Copyright © 2016 Austin Bagley. All rights reserved.
//

import UIKit

class UpdateProfileViewController: BaseViewController {
    
    
    // MARK: Properties
    
    var server = Server.sharedInstance
    let uid = Server.sharedInstance.currentUid!
    let SEGUE_TO_DASHBOARD = "returnToDashboard"
    
    // MARK: View Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSlideMenuButton()
        loadUser()
    }
    
    
    // MARK: Outlets
    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    
    
    // MARK: Actions
    
    @IBAction func saveProfile(sender: UIBarButtonItem) {
        server.updateUserEmailAndName(email.text!, firstName: firstName.text!, lastName: lastName.text!)
        performSegueWithIdentifier(SEGUE_TO_DASHBOARD, sender: self)
    }
    
    
    // MARK: Helpers
    
    
    func loadUser() {
        server.getCurrentUser() { (success, message, user) in
            if success {
                self.firstName.text = user!.firstName!
                self.lastName.text = user!.lastName!
                self.email.text = user!.email!
            } else {
                self.onError(message)
            }
        }
    }
    
    func onError(message: String?) {
        print(message)
    }
    
    
    
    
    
}
