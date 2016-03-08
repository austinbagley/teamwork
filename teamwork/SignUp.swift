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
    
    // Signup user 
    
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
                    
                    ref.authUser(user.email!, password: user.pw!, withCompletionBlock: { error, result in
                        if error != nil {
                            print(error)
                        } else {
                            
                            print("the current user is \(CurrentUser.sharedInstance.user!.uid))")
                            // Create User Object on Firebase
                            let firebaseUser = ["uid": user.uid!, "email": user.email!, "username": user.email!, "firstName": user.firstName!, "lastName": user.lastName!]

                            usersRef.childByAppendingPath(user.uid!).setValue(firebaseUser, withCompletionBlock: { error, result in
                                if error != nil {
                                    print(error)
                                } else {
                                    print("Successfully added user to database")
                                    callBack()
                                    
                                }
                            })
                        }
                    })
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
        let endDateInterval = team.teamEndDate
        let uid = CurrentUser.sharedInstance.user!.uid!
        let usersRef = ref.childByAppendingPath(constants.firebaseUsers)
        let userRef = usersRef.childByAppendingPath(uid)
        
        print("current uid is: \(uid)")
        
        let firebaseTeam = ["teamName": team.teamName!, "teamChallengeName" : team.teamChallengeName!, "teamEndDate" : endDateInterval!, "users": [uid : "true"] ]
        
        teamRef.childByAutoId().setValue(firebaseTeam, withCompletionBlock : {
            (error:NSError?, ref:Firebase!) in
            if (error != nil) {
                print("Data could not be saved.")
            } else {
                print("Team saved successfully!")
                CurrentUser.sharedInstance.currentTeam?.id = ref.key
                CurrentUser.sharedInstance.user?.currentTeam = ref.key
                print("Current User Team = \(CurrentUser.sharedInstance.currentTeam)")
                userRef.updateChildValues(["currentTeam": ref.key])
                userRef.childByAppendingPath("teams").setValue([ref.key: "true"], withCompletionBlock : {
                    (error: NSError?, ref: Firebase!) in
                    if (error != nil) {
                        print("Data could not be saved")
                    } else {
                        print("user updated with team id")
                        print(CurrentUser.sharedInstance.currentTeam?.id)
                        callBack()
                    }
                })
            }
            
        })
        
        return(team)
    }
    
    
    func updateTeamandUser(team: Team, callBack: () -> Void) {
        
        
        let ref = self.baseRef
        let teamRef = ref.childByAppendingPath("teams")
        let uid = (CurrentUser.sharedInstance.user?.uid)! as String
        let id = team.id! as String
        let targetTeamRef = teamRef.childByAppendingPath(team.id).childByAppendingPath("users")
        let newUser = [ uid : "true"]
        let userRef = ref.childByAppendingPath("users").childByAppendingPath(uid)
        
        
        // Update Team with New User
        

        targetTeamRef.updateChildValues(newUser, withCompletionBlock: {
            (error: NSError?, ref: Firebase!) in
            if (error != nil) {
                print("Data could not be saved")
            } else {
                print("updated team with new user")
                // Update User
                
                userRef.childByAppendingPath("teams").setValue([id: "true"], withCompletionBlock: {
                    (error: NSError?, ref: Firebase!) in
                    if (error != nil) {
                        print("Data could not be saved")
                    } else {
                        print("updated user with team list")
                        userRef.updateChildValues(["currentTeam": id], withCompletionBlock: {
                            (error: NSError?, ref: Firebase!) in
                            if (error != nil) {
                                print("issue updating current team")
                                print(error)
                            } else {
                                callBack()
                                print("woohoo!!!! we updated the user & team by joining an existing team")
                            }
                        })
                        
                    }
                })
            }
        })
    }
    
    // Create Goal
    
    func createWeightGoalFromSignup(startWeight: Double, endWeight: Double, callBack: () -> Void) {
        
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
            "totalWeightLoss": weightGoal.totalWeightLoss! as NSNumber,
            "currentWeight" : weightGoal.currentWeight! as NSNumber,
            "achieveTitle": "",
            "isAchieved": "false"
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

    
    // Pull Users & Goals from within team
    
    func getListandPopulateTeamNames(team: Team?, callBack: () -> Void) {
        
        getUserList(team) {
            let userList = CurrentUser.sharedInstance.teamList
            self.populateTeamData(userList!, team: team) {
                callBack()
            }
        }
    }
    
    
    func getUserList(team: Team?, callBack: () -> Void) {
        
        var userList = [String]()
        CurrentUser.sharedInstance.teamList = [String]()

        let ref = self.baseRef
        let teamsRef = ref.childByAppendingPath("teams")
        let currentTeamUsersRef = teamsRef.childByAppendingPath(team?.id).childByAppendingPath("users")
        
        
        currentTeamUsersRef.observeEventType(.Value, withBlock: { snapshot in
            let users = snapshot.value as! NSDictionary
            
            let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
            dispatch_async(dispatch_get_global_queue(priority, 0)) {
                
                for (user, _) in users {
                    let userId = (user as! String)
                    userList.append(userId)
                }
                
                dispatch_async(dispatch_get_main_queue()) {
                    CurrentUser.sharedInstance.teamList = userList
                    callBack()
                }
            }
        })
    }
    
    func getTeamNames(callBack: () -> Void) {
        
        let ref = self.baseRef
        let teamRef = ref.childByAppendingPath("teams")
        var teamArray = [String]()
        var teamsArray = [Team]()
        
        let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
        dispatch_async(dispatch_get_global_queue(priority, 0)) {
            // do some task
            
            
            teamRef.observeSingleEventOfType(.Value, withBlock:  { snapshot in
                let teams = snapshot.value as! NSDictionary
                
                for (_, teams) in teams {
                    let teamName = (teams["teamName"] as! String)
                    teamArray.append(teamName)
                }
                
                for (id, teams) in teams {
                    let fbTeam =
                    Team(
                        id: (id as! String),
                        teamName: (teams["teamName"] as! String),
                        teamChallengeName: (teams["teamChallengeName"] as! String),
                        endDate: (teams["teamEndDate"] as! NSTimeInterval)
                    )
                    teamsArray.append(fbTeam)
                }
                
                TeamList.sharedInstance.teamList = teamsArray
                
                dispatch_async(dispatch_get_main_queue()) {
                    callBack()
                }
            })
            
            
        }
    }

    
    func populateTeamData(userList: [String], team: Team?, callBack: () -> Void) {
        let ref = self.baseRef
        let usersRef = ref.childByAppendingPath("users")
        let goalsRef = ref.childByAppendingPath("goals")
        let userList = userList
        var teamUsers = [TeamUser]()
        
        let maxQueryCount = userList.count
        var queryCount = 0
        
        
        for user in userList {
            
            let teamUserRef = usersRef.childByAppendingPath(user)
            teamUserRef.observeEventType(.Value, withBlock:  { result in
                let userObject = result.value as! NSDictionary
                let newUser = User(uid: ((userObject["uid"]) as! String), email: ((userObject["email"]) as! String), currentTeam: ((userObject["currentTeam"]) as! String), firstName: ((userObject["firstName"]) as! String), lastName: ((userObject["lastName"]) as! String))
                
                let query = goalsRef.queryOrderedByChild("uid").queryEqualToValue(user)
                
                query.observeEventType(.Value, withBlock: { goalResult in
                    
                    if goalResult.value is NSNull {
                        let newGoal = Goal()
                        let newTeamUser = TeamUser(user: newUser, goal: newGoal)
                        teamUsers.append(newTeamUser)
                        queryCount += 1
                        
                    } else {
                        let goalData = goalResult.value as! NSDictionary
                        let goalId = goalResult.key
                        
                        for (_, goalObject) in goalData {
                            let isWeightGoal = goalObject["isWeightGoal"] as! String
                            let startWeight = goalObject["startWeight"] as! Double
                            let endWeight = goalObject["endWeight"] as! Double
                            let currentWeight = goalObject["currentWeight"] as! Double
                            let isAchieved = ""
                            let achieveTitle = ""
                            
                            let newGoal = Goal(goalId: goalId, user: newUser, isWeightGoal: isWeightGoal, startWeight: startWeight, endWeight: endWeight, currentWeight: currentWeight, achieveTitle: achieveTitle, isAchieved: isAchieved)
                            
                            let newTeamUser = TeamUser(user: newUser, goal: newGoal)
                            teamUsers.append(newTeamUser)
                            queryCount += 1
                        }
                    }
                    
                    if queryCount == maxQueryCount {
                        CurrentUser.sharedInstance.teamUsers = teamUsers
                        
                        // remove current user
                        
                        
                        
                        
                        
                        callBack()
                    }
                })
            })
        }
    }
    

    
    
    
    
    
}