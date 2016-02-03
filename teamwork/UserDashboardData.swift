//
//  UserDashboardData.swift
//  Meta
//
//  Created by Austin Bagley on 1/19/16.
//  Copyright © 2016 Bagley. All rights reserved.
//

import Foundation

class UserDashboardData {
    
    static var sharedInstance = UserDashboardData()
    
    private init() {
        
        
    }
    
    var user: User?
    var team: Team?
    var goal: Goal?
    var subGoal: [SubGoal]?
    
    
    // Actions
    
    func refresh(user: String, callBack: () -> Void) {
        self.user = nil
        let teamId = ""
        print(teamId)
        
        
        
        // grab team and goal from firebase api
    }
    
    
    
    
    
    
}
