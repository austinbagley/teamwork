//
//  SubGoal.swift
//  Meta
//
//  Created by Austin Bagley on 1/14/16.
//  Copyright © 2016 Bagley. All rights reserved.
//

import Foundation


class SubGoal {
    
    var goal: Goal
    var subGoalTitle: String?
    var isAchieved: Bool?

    
    
    // CREATE
    
    init(goal: Goal, SubGoalTitle: String?) {
        self.goal = goal
        self.subGoalTitle = SubGoalTitle
        self.isAchieved = false
    
    }
    
}



