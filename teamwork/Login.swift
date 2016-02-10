//
//  LogIn.swift
//  teamwork
//
//  Created by Austin Bagley on 2/8/16.
//  Copyright © 2016 Austin Bagley. All rights reserved.
//

import Foundation
import Firebase

class Login {

    var baseRef: Firebase {
        get {
            return Firebase(url: fb.firebaseUrl)
        }
    }
    let fb = FirebaseConstants.sharedInstance
    let currentUser = CurrentUser.sharedInstance
    let signUp = SignUp()


    func login(email: String, pw: String, callBack: () -> Void) {
        let ref = self.baseRef
        
        ref.authUser(email, password: pw) {
            error, authData in
            if error != nil {
                print(error)
            } else {
                print("login successful with uid: \(authData.uid)")
                // create current user
                self.getUserforUserId(authData.uid) {
                    print("current user generated with first name of \(self.currentUser.user!.firstName!)")
                    
                    // create current team
                    self.getCurrentTeamForUser(self.currentUser.user) {
                        print("current team generated with challenge name: \(self.currentUser.currentTeam!.teamChallengeName!)")
                        
                        // create current goal
                        self.getCurrentGoalForUser(self.currentUser.user) {
                            print("current goal weight loss is \(self.currentUser.currentGoal!.totalWeightLoss!)")
                            print("current weight is \(self.currentUser.currentGoal!.currentWeight!)")
                            
                            // populate team member list
                            self.signUp.getUserList(self.currentUser.currentTeam) {
                                
                                // create teamUsers
                                self.signUp.populateTeamData(self.currentUser.teamList!, team: self.currentUser.currentTeam) {
                                    print("number of team members is  \(self.currentUser.teamUsers!.count)")
                                    
                                    // callBack to View Controller
                                    callBack()
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    func getUserforUserId(uid: String, callBack: () -> Void) {
        
        let userRef = baseRef.childByAppendingPath(fb.firebaseUsers).childByAppendingPath(uid)
        userRef.observeEventType(.Value, withBlock: { result in
            let userObject = result.value as! NSDictionary
            
            let newUser = User(uid: ((userObject["uid"]) as! String), email: ((userObject["email"]) as! String), currentTeam: ((userObject["currentTeam"]) as! String), firstName: ((userObject["firstName"]) as! String), lastName: ((userObject["lastName"]) as! String))
            
            self.currentUser.user = newUser
            
            callBack()
        })
    }
    
    func getCurrentTeamForUser(user: User?, callBack: () -> Void) {
        
        let teamId = user?.currentTeam
        let teamRef = baseRef.childByAppendingPath(fb.firebaseTeams).childByAppendingPath(teamId)
        
        teamRef.observeEventType(.Value, withBlock: { result in
            let teamObject = result.value as! NSDictionary
            
            let newTeam = Team(
                teamId: (result.key as String),
                teamName: (teamObject["teamName"] as! String),
                teamChallengeName: (teamObject["teamChallengeName"] as! String),
                endDate: (NSDate(timeIntervalSince1970: (teamObject["teamEndDate"] as! NSTimeInterval)))
            )
            
            self.currentUser.currentTeam = newTeam
        
            callBack()
        })
    }
    
    
    func getCurrentGoalForUser(user: User?, callBack: () -> Void) {
        
        let teamId = user!.currentTeam!
        let uid = user!.uid!
        
        let goalRef = baseRef.childByAppendingPath(fb.firebaseGoals)
        let query = goalRef.queryOrderedByChild("uid").queryEqualToValue(uid)
    
        query.observeEventType(.Value, withBlock: { goalResult in
            let goalData = goalResult.value as! NSDictionary
            
            for (goal, goalObject) in goalData {
                
                let goalId = goal as! String
                
                let goalTeamId = goalObject["teamId"] as! String
                
                if goalTeamId == teamId {
                    let isWeightGoal = goalObject["isWeightGoal"] as! String
                    let startWeight = goalObject["startWeight"] as! Double
                    let endWeight = goalObject["endWeight"] as! Double
                    let currentWeight = goalObject["currentWeight"] as! Double
                    let isAchieved = ""
                    let achieveTitle = ""
                
                    let newGoal = Goal(goalId: goalId, user: user, isWeightGoal: isWeightGoal, startWeight: startWeight, endWeight: endWeight, currentWeight: currentWeight, achieveTitle: achieveTitle, isAchieved: isAchieved)
                    
                    self.currentUser.currentGoal = newGoal
                    
                    callBack()
                }
            }
        })
    }
    
    
    
}
