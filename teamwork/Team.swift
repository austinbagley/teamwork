//
//  File.swift
//  Meta
//
//  Created by Austin Bagley on 1/12/16.
//  Copyright © 2016 Bagley. All rights reserved.
//

import Parse
import Foundation

class Team: PFObject, PFSubclassing {
    
    // Constants
    
    let PFClassName = "Team"

    
    override class func initialize() {
        struct Static {
            static var onceToken : dispatch_once_t = 0;
        }
        dispatch_once(&Static.onceToken) {
            self.registerSubclass()
        }
    }
    
    static func parseClassName() -> String {
        return "Team"
    }
    
    @NSManaged var teamName: String?
    @NSManaged var teamChallengeName: String?
    @NSManaged var teamPassword: String?
    @NSManaged var teamEndDate: NSDate?
    
    
    
    // Create
    
    init(teamName: String, teamChallengeName: String, teamPassword: String, endDate: NSDate) {
        super.init()
        self.teamName = teamName
        self.teamChallengeName = teamChallengeName
        self.teamPassword = teamPassword
        self.teamEndDate = endDate
        print("team original creation: \(self)")
    }
    
    // Read
    
    override init() {
        super.init()
        teamName = nil
        teamChallengeName = nil
        teamPassword = nil
        teamEndDate = nil
    }
    
    init(id: String) {
        super.init()
        
        // Initialize with nil
        teamName = nil
        teamChallengeName = nil
        teamPassword = nil
        teamEndDate = nil
        
        let query = PFQuery(className: PFClassName)
        query.getObjectInBackgroundWithId(id) {
            (team: PFObject?, error: NSError?) -> Void in
            if error == nil && team != nil {
                    print(team)
                self.teamName = (team!["teamName"] as? String)!
                self.teamChallengeName = (team!["challengeName"] as? String)!
                self.teamPassword = (team!["teamPassword"] as? String)!
                self.teamEndDate = (team!["endDate"] as? NSDate!)!
            } else {
                print(error)
            }
        }
    }
    
   
    
}
