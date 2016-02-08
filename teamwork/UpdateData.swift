//
//  UpdateData.swift
//  teamwork
//
//  Created by Austin Bagley on 2/4/16.
//  Copyright © 2016 Austin Bagley. All rights reserved.
//

import Foundation
import Firebase

class UpdateData {
    
    // MARK: Properties
    
    var baseRef = Firebase(url: "https://radiant-fire-3697.firebaseio.com")
    
    
    // MARK: Grab Functions
    
    
    // grab team names
    
    func getTeamNames(callBack: () -> Void) {
        
        let ref = self.baseRef
        let teamRef = ref.childByAppendingPath("teams")
        var teamArray = [String]()
        var teamsArray = [Team]()
        
        let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
        dispatch_async(dispatch_get_global_queue(priority, 0)) {
            // do some task
            
        
        teamRef.observeSingleEventOfType(.Value, withBlock:  { snapshot in
            let teams = snapshot.value as! NSDictionary
            
            for (_, teams) in teams {
                let teamName = (teams["teamName"] as! String)
                teamArray.append(teamName)
            }
            
            for (id, teams) in teams {
                let fbTeam =
                    Team(
                        teamId: (id as! String),
                        teamName: (teams["teamName"] as! String),
                        teamChallengeName: (teams["teamChallengeName"] as! String),
                        endDate: (NSDate(timeIntervalSince1970: (teams["teamEndDate"] as! NSTimeInterval)))
                    )
                teamsArray.append(fbTeam)
            }

            TeamList.sharedInstance.teamList = teamsArray
            TeamNames.sharedInstance.teamNames = teamArray
            
            dispatch_async(dispatch_get_main_queue()) {
                callBack()
            }
        })
            
            
        }
    }
    
    
    
    
    
    
    
    
    
}
