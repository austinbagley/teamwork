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
                CurrentUser.sharedInstance.currentTeam?.teamId = ref.key
                CurrentUser.sharedInstance.user?.currentTeam = ref.key
                print("Current User Team = \(CurrentUser.sharedInstance.currentTeam)")
                userRef.updateChildValues(["currentTeam": ref.key])
                userRef.childByAppendingPath("teams").setValue([ref.key: "true"], withCompletionBlock : {
                    (error: NSError?, ref: Firebase!) in
                    if (error != nil) {
                        print("Data could not be saved")
                    } else {
                        print("user updated with team id")
                        print(CurrentUser.sharedInstance.currentTeam?.teamId)
                        callBack()
                    }
                })
            }
            
        })
        
        return(team)
    }
    
    ///// THIS IS WHERE I'M WORKING. THIS SEEMED TO DELETE THE CHILD NODES FOR teams UNDER user AND FOR users UNDER team ///
    
    func updateTeamandUser(team: Team, callBack: () -> Void) {
        
        let ref = self.baseRef
        let teamRef = ref.childByAppendingPath("teams")
        let uid = (CurrentUser.sharedInstance.user?.uid)! as String
        let teamId = team.teamId! as String
        let targetTeamRef = teamRef.childByAppendingPath(team.teamId).childByAppendingPath("users")
        let newUser = [ uid : "true"]
        let userRef = ref.childByAppendingPath("users").childByAppendingPath(uid)
        
        
        // Update Team with New User
        

        targetTeamRef.updateChildValues(newUser, withCompletionBlock: {
            (error: NSError?, ref: Firebase!) in
            if (error != nil) {
                print("Data could not be saved")
            } else {
                
                // Update User
                
                userRef.childByAppendingPath("teams").setValue([teamId: "true"], withCompletionBlock: {
                    (error: NSError?, ref: Firebase!) in
                    if (error != nil) {
                        print("Data could not be saved")
                    } else {
                        userRef.updateChildValues(["currentTeam": teamId])
                        callBack()
                        print("woohoo!!!! we updated the user & team by joining an existing team")
                    }
                })
            }
        })
    }
    
    // Create Goal
    
    func createWeightGoalFromSignup(startWeight: Double, endWeight: Double, team: Team, callBack: () -> Void) {
        
        let ref = self.baseRef
        let goalRef = ref.childByAppendingPath("goals")
        
        let weightGoal = Goal(startWeight: startWeight, endWeight: endWeight)
        let firebaseGoal =
            [
            "uid":(CurrentUser.sharedInstance.user?.uid)! as String,
            "teamId": (CurrentUser.sharedInstance.user?.currentTeam)! as String,
            "isWeightGoal": "true" as String,
            "startWeight": weightGoal.startWeight! as NSNumber,
            "endWeight" : weightGoal.endWeight! as NSNumber,
            "totalWeightLoss": weightGoal.totalWeightLoss! as NSNumber
            ]
        
        goalRef.childByAutoId().setValue(firebaseGoal, withCompletionBlock:  {
            (error: NSError?, ref: Firebase!) in
            if (error != nil) {
                print("Data could not be saved")
            } else {
                print("goal created for current user")
                
                weightGoal.goalId = ref.key
                weightGoal.team = CurrentUser.sharedInstance.currentTeam
                weightGoal.user = CurrentUser.sharedInstance.user
                CurrentUser.sharedInstance.currentGoal = weightGoal
                callBack()
            }
        })
    
    }
    
    
    

    
    
    
    
    
    
    
    
}