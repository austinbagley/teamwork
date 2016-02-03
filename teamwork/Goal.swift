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
    
     var isWeightGoal: String?
     var startWeight: NSNumber?
     var endWeight: NSNumber?
     var totalWeightLoss: NSNumber?
     var achieveTitle: String?
     var isAchieved: String?
    
    // Create
    
    init(startWeight: Double, endWeight: Double) {
        user = nil
        isWeightGoal = "true"
        self.startWeight = startWeight
        self.endWeight = endWeight
        totalWeightLoss = startWeight - endWeight
        achieveTitle = nil
        isAchieved = nil
        
        self.team = nil
        
    }
}
