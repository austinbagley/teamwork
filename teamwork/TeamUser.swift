//
//  File.swift
//  teamwork
//
//  Created by Austin Bagley on 2/4/16.
//  Copyright © 2016 Austin Bagley. All rights reserved.
//

import Foundation


class TeamUser {
    
    var user: User?
    var goal: Goal?
 
    
    init(user: User?, goal: Goal?) {
        self.user = user
        self.goal = goal
    }
}
