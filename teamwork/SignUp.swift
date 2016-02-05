//
//  File.swift
//  Meta
//
//  Created by Austin Bagley on 1/14/16.
//  Copyright © 2016 Bagley. All rights reserved.
//

import Foundation
import Firebase


class SignUp {
    
    // Properties
    
    let constants = FirebaseConstants.sharedInstance
    var team: Team?
    var baseRef: Firebase {
        get {
            return Firebase(url: constants.firebaseUrl)
        }
    }
    
    // Signup user with Parse
    
    func signUpNewUser(password: String?, email: String?, firstName: String?, lastName: String?, callBack: () -> Void) {
        let user = User(pw: password!, email: email!, firstName: firstName!, lastName: lastName!)
        let ref = self.baseRef
        let usersRef = ref.childByAppendingPath(constants.firebaseUsers)
        
        ref.createUser(user.email, password: user.pw,
            withValueCompletionBlock: { error, result in
                if error != nil {
                    // There was an error creating the account
                    print(error)
                } else {
                    let uid = result["uid"] as? String
                    print("Successfully created user account with uid: \(uid)")
                    user.uid = uid!
                    CurrentUser.sharedInstance.user = user
                    CurrentUser.sharedInstance.user!.uid = result["uid"] as? String
                    print("the current user is \(CurrentUser.sharedInstance.user!.uid))")
        
                    // Create User Object on Firebase
                    
                    print(usersRef)
                    let firebaseUser = ["uid": user.uid!, "email": user.email!, "username": user.email!, "firstName": user.firstName!, "lastName": user.lastName!]
                    print(firebaseUser)
                    
                    usersRef.childByAppendingPath(user.uid!).setValue(firebaseUser)
                    callBack()
                }
        })
    }
    
    // Create Team Object, Push to Parse
    
    func createTeam(teamName: String!, teamChallengeName: String!, teamPassword: String!, endDate: NSDate!, callBack: () -> Void) -> Team {
        
        let team = Team(teamName: teamName, teamChallengeName: teamChallengeName, teamPassword: teamPassword, endDate: endDate!)
        self.team = team
        CurrentUser.sharedInstance.currentTeam = team
        
        // upload team to firebase
        let ref = self.baseRef
        let teamRef = ref.childByAppendingPath(constants.firebaseTeams)
        let endDateInterval = team.teamEndDate?.timeIntervalSince1970
        let uid = CurrentUser.sharedInstance.user!.uid!
        let usersRef = ref.childByAppendingPath(constants.firebaseUsers)
        let userRef = usersRef.childByAppendingPath(uid)
        
        print("curernt uid is: \(uid)")
        
        let firebaseTeam = ["teamName": team.teamName!, "teamChallengeName" : team.teamChallengeName!, "teamEndDate" : endDateInterval!, "users": [uid : "true"] ]
        
        teamRef.childByAutoId().setValue(firebaseTeam, withCompletionBlock : {
            (error:NSError?, ref:Firebase!) in
            if (error != nil) {
                print("Data could not be saved.")
            } else {
                print("Team saved successfully!")
                userRef.childByAppendingPath("teams").setValue([ref.key: "true"], withCompletionBlock : {
                    (error: NSError?, ref: Firebase!) in
                    if (error != nil) {
                        print("Data could not be saved")
                    } else {
                        print("user updated with team id")
                        callBack()
                    }
                })
            }
            
        })
        
        return(team)
    }
    
    // Create Goal
    
    func createWeightGoalFromSignup(startWeight: Double, endWeight: Double, team: Team, callBack: () -> Void) -> Goal {
        var result: Goal?
        
        let goal = Goal(startWeight: startWeight, endWeight: endWeight)
        
        goal.team = team
        
        // save goal to firebase
        
        return result!
    }
    
    
    

    
    
    
    
    
    
    
    
}