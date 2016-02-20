//
//  FirebaseConstants.swift
//  teamwork
//
//  Created by Austin Bagley on 2/2/16.
//  Copyright © 2016 Austin Bagley. All rights reserved.
//

import Foundation
import Firebase

// Firebase Constants

class FirebaseConstants {
    
    static var sharedInstance = FirebaseConstants()
    
    private init() {}
    
//    // enable persistance
//    func enableFirebasePersistance() {
//        Firebase.defaultConfig().persistenceEnabled = true
//    }
    
    
//    let firebaseUrl = "https://dev-teamwork.firebaseio.com/"
    let firebaseUrl = "https://beta-teamwork.firebaseio.com/"
    let firebaseUsers = "users"
    let firebaseTeams = "teams"
    let firebaseGoals = "goals"

    // team
    
    let teamName = "teamName"
    let teamChallengeName = "teamChallengeName"
    let teamEndDate = "teamEndDate"
    let teamUsers = "teamUsers"
    
    // users
    
    let email = "email"
    let uid = "uid"
    let firstName = "firstName"
    let lastName = "lastName"
    let teams = "teams"
    
    // goals
    
    let user = "user"
    let team = "team"
    let isWeightGoal = "isWeightGoal"
    let startWeight = "startWeight"
    let endWeight = "endWeight"
    let totalWeightLoss = "totalWeightLoss"
    let achieveTitle = "achieveTitle"
    let isAchieved = "isAchieved"
    
    
}
