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
    
    let update = UpdateData()
    let SEGUE_UNWIND_SAVE = "finishUpdate"
    let SEGUE_UNWIND_SAVE_ALT = "finishSave"
    
    
    // MARK : Outlets
    
    @IBOutlet weak var currentWeight: UITextField!
    
    
    // MARK : View Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.currentWeight.delegate = self
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
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
        update.updateWeight(weight!) {
            print("it worked?")
            self.performSegueWithIdentifier(self.SEGUE_UNWIND_SAVE_ALT, sender: self)
        }
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue == SEGUE_UNWIND_SAVE {
            let weight = Double(currentWeight.text!)
            update.updateWeight(weight!) {
                print("it worked?")
            }
        }
    }
    
   
    
    
}
