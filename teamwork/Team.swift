//
//  File.swift
//  Meta
//
//  Created by Austin Bagley on 1/12/16.
//  Copyright © 2016 Bagley. All rights reserved.
//

import Foundation

class Team {
    
    // Constants
    
    var teamName: String?
    var teamChallengeName: String?
    var teamPassword: String?
    var teamEndDate: NSDate?
    
    // Create
    
    init(teamName: String, teamChallengeName: String, teamPassword: String, endDate: NSDate) {
        self.teamName = teamName
        self.teamChallengeName = teamChallengeName
        self.teamPassword = teamPassword
        self.teamEndDate = endDate
        print("team original creation: \(self)")
    }
}
