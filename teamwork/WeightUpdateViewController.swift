//
//  WeightUpdateViewController.swift
//  teamwork
//
//  Created by Austin Bagley on 2/8/16.
//  Copyright © 2016 Austin Bagley. All rights reserved.
//

import UIKit

class WeightUpdateViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: Properties
    
    let SEGUE_UNWIND_SAVE = "finishUpdate"
    let SEGUE_UNWIND_SAVE_ALT = "finishSave"
    
    
    // MARK : Outlets
    
    @IBOutlet weak var currentWeight: UITextField!
    
    // MARK: Properties
    
    var goalId: String?
    var priorWeight: Double?
    var newWeight: Double?
    var server = Server.sharedInstance
    
    
    // MARK : View Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.currentWeight.delegate = self
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(WeightUpdateViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        
    }
    
    // MARK : Actions
    
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }

    
    @IBAction func save(sender: UIBarButtonItem) {
        let weight = Double(currentWeight.text!)
        let priorWeight = self.priorWeight!
        let goalId = self.goalId!
        
        server.updateWeight(goalId, currentWeight: weight!, priorWeight: priorWeight) { (success, message) in
            if success {
                self.performSegueWithIdentifier(self.SEGUE_UNWIND_SAVE, sender: self)
            } else {
                print(message)
            }
        }
    }

}
