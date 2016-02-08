//
//  CurrentUser.swift
//  teamwork
//
//  Created by Austin Bagley on 2/3/16.
//  Copyright © 2016 Austin Bagley. All rights reserved.
//

import Foundation


class CurrentUser {
    
    static let sharedInstance = CurrentUser()
    private init() {
    }
    
    var user: User?
    var currentTeam: Team?
    var currentGoal: Goal?
    var teamUsers: [TeamUser]?
    var teamList: [String]?
}
