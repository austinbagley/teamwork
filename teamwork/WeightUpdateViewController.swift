//
//  WeightUpdateViewController.swift
//  teamwork
//
//  Created by Austin Bagley on 2/8/16.
//  Copyright © 2016 Austin Bagley. All rights reserved.
//

import UIKit

class WeightUpdateViewController: UIViewController {
    
    // MARK: Properties
    
    let update = UpdateData()
    let SEGUE_UNWIND_SAVE = "finishUpdate"
    
    
    // MARK : Outlets
    
    @IBOutlet weak var currentWeight: UITextField!
    
    // MARK : Actions
    
    @IBAction func update(sender: UIButton) {
        let weight = Double(currentWeight.text!)
        update.updateWeight(weight!) {
            print("it worked?")
            self.performSegueWithIdentifier(self.SEGUE_UNWIND_SAVE, sender: self)
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
