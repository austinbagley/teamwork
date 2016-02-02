//
//  SubGoal.swift
//  Meta
//
//  Created by Austin Bagley on 1/14/16.
//  Copyright © 2016 Bagley. All rights reserved.
//

import Foundation
import Parse


class SubGoal: PFObject, PFSubclassing {
    
    override class func initialize() {
        struct Static {
            static var onceToken : dispatch_once_t = 0;
        }
        dispatch_once(&Static.onceToken) {
            self.registerSubclass()
        }
    }
    
    static func parseClassName() -> String {
        return "SubGoal"
    }

    
    @NSManaged var goal: Goal
    
    var subGoalTitle: String?
    var isAchieved: Bool?

    
    
    // CREATE
    
    init(goal: Goal, SubGoalTitle: String?) {
        super.init()
        self.goal = goal
        self.subGoalTitle = SubGoalTitle
        self.isAchieved = false
    
    }
    
    // Actions
    
    func getSubGoalObjectsForGoalObject(goal: Goal) -> [SubGoal] {
        let query = SubGoal.query()
        var subGoals = [SubGoal]()
        
        query!.whereKey("goal", equalTo: goal)
        query!.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                if let objects = objects as? [SubGoal] {
                    subGoals = objects
                }
            }
        }
        
        return subGoals
        
    }

}



