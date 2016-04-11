//
//  File.swift
//  Meta
//
//  Created by Austin Bagley on 1/12/16.
//  Copyright © 2016 Bagley. All rights reserved.
//

import Foundation

class Team: NSObject {
    
    // Constants
    
    var id: String?
    var teamName: String?
    var teamChallengeName: String?
    var teamPassword: String?
    var teamEndDate: NSTimeInterval?
    var users: [TeamUser]?
    var posts: [Post]?
    
    // Create
    
    init(teamName: String, teamChallengeName: String, teamPassword: String, endDate: NSDate) {
        let endDate: NSDate = endDate
        
        self.id = nil
        self.teamName = teamName
        self.teamChallengeName = teamChallengeName
        self.teamPassword = teamPassword
        self.teamEndDate = endDate.timeIntervalSince1970
    }
    
    
    init(id: String, teamName: String, teamChallengeName: String, endDate: NSTimeInterval, users: [TeamUser]?) {
        self.id = id
        self.teamName = teamName
        self.teamChallengeName = teamChallengeName
        self.teamPassword = nil
        self.teamEndDate = endDate
        self.users = users
    }
    
    override init() {
        
    }
    
   
    
    
}
