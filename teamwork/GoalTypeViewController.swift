//
//  GoalTypeViewController.swift
//  ParseStarterProject-Swift
//
//  Created by Austin Bagley on 1/2/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit


class GoalTypeViewController: UIViewController {
    
    
    // MARK: Constants
    
    let SEGUE_TO_WEIGHT_GOAL = "showWeightGoal"
    let SEGUE_TO_ACHIEVEMENT_GOAL = "showAchievementGoal"
    
    // MARK: Properties
    
    var isWeightGoal = true
    
    // MARK: Outlets
    
    @IBOutlet weak var goalType: UISegmentedControl!
    
    // MARK: View Controller lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController!.navigationBar.hidden = false
        self.navigationItem.setHidesBackButton(true, animated: false)
    }
    
    // MARK: Actions
    
    @IBAction func nextScreen(sender: UIButton) {
           self.performSelectedSegue()
    }
    
    @IBAction func goalTypeControl(sender: UISegmentedControl) {
        if self.goalType.selectedSegmentIndex == 0 {
            self.isWeightGoal = true
        } else {
            self.isWeightGoal = false
        }
    }
    
    func performSelectedSegue() {
        if isWeightGoal {
            self.performSegueWithIdentifier(SEGUE_TO_WEIGHT_GOAL, sender: self)
        } else {
            self.performSegueWithIdentifier(SEGUE_TO_ACHIEVEMENT_GOAL, sender: self)
        }
    }
    
    

    
    
    
    
}
