//
//  Goal.swift
//  Meta
//
//  Created by Austin Bagley on 1/14/16.
//  Copyright © 2016 Bagley. All rights reserved.
//

import Foundation

class Goal {
    
     var user: User?
     var team: Team?
    
     var goalId: String?
     var isWeightGoal: String?
     var startWeight: NSNumber?
     var endWeight: NSNumber?
     var currentWeight: NSNumber?
     var lostSoFar: NSNumber?
     var totalWeightLoss: NSNumber?
     var achieveTitle: String?
     var isAchieved: String?
    
    // Create
    
    init(startWeight: Double, endWeight: Double) {
        self.user = nil
        self.team = nil
        self.goalId = nil
        isWeightGoal = "true"
        self.startWeight = startWeight
        self.endWeight = endWeight
        self.currentWeight = startWeight
        totalWeightLoss = startWeight - endWeight
        self.lostSoFar = 0
        achieveTitle = nil
        isAchieved = nil
    }
    
    init(goalId: String, user: User?, isWeightGoal: String?, startWeight: Double?, endWeight: Double?, currentWeight: Double?, achieveTitle: String?, isAchieved: String?) {
        self.user = user
        self.team = nil
        self.goalId = goalId
        self.isWeightGoal = isWeightGoal
        self.startWeight = startWeight
        self.endWeight = endWeight
        self.currentWeight = currentWeight
        
        
        if startWeight != nil && endWeight != nil {
            totalWeightLoss = startWeight! - endWeight!
            lostSoFar = startWeight! - currentWeight!
        } else {
            totalWeightLoss = 0
            lostSoFar = 0
        }
       
        if isWeightGoal != "true" {
            self.achieveTitle = achieveTitle!
            self.isAchieved = isAchieved!
        } else {
            self.achieveTitle = nil
            self.isAchieved = nil
        }
    }
    
    
    init() {
        self.user = nil
        self.team = nil
        self.goalId = nil
        self.isWeightGoal = nil
        self.startWeight = nil
        self.endWeight = nil
        self.currentWeight = nil
        self.totalWeightLoss = nil
        self.lostSoFar = nil
        self.achieveTitle = nil
        self.isAchieved = nil
    }

    
    
}
