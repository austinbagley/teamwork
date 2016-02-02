//
//  File.swift
//  Meta
//
//  Created by Austin Bagley on 1/14/16.
//  Copyright © 2016 Bagley. All rights reserved.
//

import Foundation
import Parse


class SignUp {
    
    // Properties
    
    var team = Team() {
        didSet {
            if team != oldValue  {
                teamChanged = true
                print(teamChanged)
            }
        }
    }
    
    var teamChanged = false

    
    
    
    // Signup user with Parse
    
    func signUpNewUser(password: String?, email: String?, firstName: String?, lastName: String?, callBack: () -> Void) -> String? {
        
        var responseString = ""
        
        
        
        
        // Insert User Signup Here
        
        let user = PFUser()
        
        user.username = email
        user.password = password
        user.email = email
        // other fields can be set just like with PFObject
        user["firstName"] = firstName
        user["lastName"] = lastName
        
        user.signUpInBackgroundWithBlock {
            (succeeded: Bool, error: NSError?) -> Void in
            if let error = error {
                let errorString = error.userInfo["error"] as! String?
                responseString = errorString!
                print(responseString)
            } else {
                // Hooray! Let them use the app now.
                responseString = "Success"
                print(responseString)
                callBack()
            }
        }
        return responseString
    }
    
    // Create Team Object, Push to Parse
    
    func createTeam(teamName: String, teamPassword: String, endDate: NSDate?, callBack: () -> Void) -> Team {
        
        self.team = Team(teamName: teamName, teamChallengeName: teamName, teamPassword: teamPassword, endDate: endDate!)
        
        team.saveInBackgroundWithBlock {
            (success: Bool, error: NSError?) -> Void in
            if (success) {
                print("team creation succeeded")
                callBack()
            } else {
                print("team creation failed")
            }
        }
        return(team)
    }
    
    // Update user with Team Id
    
    func updateUserWithTeamId(team: Team) {
        let currentUser = (PFUser.currentUser()!.objectId!)
        print("User Object ID is: \(currentUser)")
        
        let query = PFUser.query()
        query!.getObjectInBackgroundWithId(currentUser) {
            (user: PFObject?, error: NSError?) -> Void in
            if error != nil {
                print(error)
            } else if let user = user {
                user["teamObjectId"] = team.objectId! as String
                user.saveInBackground()
            }
        }
    
        
    }
    
    
    // Create Goal
    
    func createWeightGoalFromSignup(startWeight: Double, endWeight: Double, team: Team, callBack: () -> Void) -> Goal {
        var result: Goal?
        let goal = Goal(startWeight: startWeight, endWeight: endWeight)
//        let team: PFObject = PFObject(className: "team")
        
        goal.team = team
        
        print("Goal team is: \(goal.team)")
        print(goal)
        print(goal.team?.teamName)
        
        result = goal
        
        goal.saveInBackgroundWithBlock {
            (success: Bool, error: NSError?) -> Void in
            if (success) {
                print("goal creation succeeded")
                print(goal)
                
                callBack()
                
            } else {
                print("goal creation failed")
            }
        }
        
        
        return result!
    }
    
    
    

    
    
    
    
    
    
    
    
}