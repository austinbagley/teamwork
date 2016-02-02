//
//  Goal.swift
//  Meta
//
//  Created by Austin Bagley on 1/14/16.
//  Copyright © 2016 Bagley. All rights reserved.
//

import Foundation
import Parse


class Goal: PFObject, PFSubclassing {
    
    // Create Parse Subclass
    
    override class func initialize() {
        struct Static {
            static var onceToken : dispatch_once_t = 0;
        }
        dispatch_once(&Static.onceToken) {
            self.registerSubclass()
        }
    }
    
    static func parseClassName() -> String {
        return "Goal"
    }
    
    
    @NSManaged var user: PFUser
    @NSManaged var team: Team?
    
    @NSManaged var isWeightGoal: String?
    @NSManaged var startWeight: NSNumber?
    @NSManaged var endWeight: NSNumber?
    @NSManaged var totalWeightLoss: NSNumber?
    @NSManaged var achieveTitle: String?
    @NSManaged var isAchieved: String?
    
   
    
    
    // Create
    
    init(startWeight: Double, endWeight: Double) {
        super.init()
        user = PFUser.currentUser()!
        isWeightGoal = "true"
        self.startWeight = startWeight
        self.endWeight = endWeight
        totalWeightLoss = startWeight - endWeight
        achieveTitle = nil
        isAchieved = nil
        
        print("Goal current user is: \(PFUser.currentUser())")
        self.team = nil
        
    }
//    init(achieveTitle: String) {
//        super.init()
//        user = PFUser.currentUser()!
//        isWeightGoal = "false"
//        startWeight = nil
//        endWeight = nil
//        totalWeightLoss = nil
//        self.achieveTitle = achieveTitle
//        isAchieved = false
//        
//        let teamId = user["userCurrentTeam"] as? String
//        self.team = getTeamObjectFromTeamObjectId(teamId)
//    
//    }
    
    // Read
    
    init(id: String) {
        super.init()
        let goal = getGoalObjectFromGoalId(id)
        
        user = goal.user
        team = goal.team
        isWeightGoal = goal.isWeightGoal
        self.startWeight = goal.startWeight
        self.endWeight = goal.endWeight
        totalWeightLoss = goal.totalWeightLoss
        achieveTitle = goal.achieveTitle
        isAchieved = goal.isAchieved
    
    }
    
    // Actions
    
    func getGoalObjectFromGoalId(id: String?) -> Goal {
        let query = Goal.query()
        var goal: Goal?
        
        query!.whereKey("objectId", equalTo: id!)
        query!.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                if let objects = objects as? [Goal], firstGoal = objects.first {
                    goal = firstGoal
                }
            }
        }
        return goal!
        
    }
    
    
    func getGoalObjectsForUserObject(user: PFUser) -> [Goal] {
        let query = Goal.query()
        var goals: [Goal]?
        
        query!.whereKey("User", equalTo: user)
        query!.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                if let objects = objects as? [Goal] {
                    goals = objects
                }
            }
        }
        
        
        return goals!
    }
    
    
    
//    func getTeamObjectFromTeamObjectId(id: String?) -> Team {
//        let query = Team.query()
//        var team: Team?
//        
//        query!.whereKey("objectId", equalTo: id!)
//        query!.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) -> Void in
//            if error == nil {
//                if let objects = objects as? [Team], firstTeam = objects.first {
//                    print(objects)
//                    print(firstTeam)
//                    team = firstTeam
//                }
//            }
//        }
//        print(team!)
//        return team!
//    }
}
