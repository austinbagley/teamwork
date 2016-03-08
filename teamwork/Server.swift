//
//  Server.swift
//  teamwork
//
//  Created by Austin Bagley on 2/17/16.
//  Copyright © 2016 Austin Bagley. All rights reserved.
//

import Foundation
import Firebase


class Server {
    
    // MARK: Constants
    
    let ref = Firebase(url: "https://beta-teamwork.firebaseio.com/")
    let fbTeams = "teams"
    let fbUsers = "users"
    let fbGoal = "goals"
    
    // MARK: Singleton
    
    static let sharedInstance = Server()
    private init() {
    }
    
    var currentUid: String?
    
    
    // MARK: User
    
    // register new user
    
    func createUser(email: String, password: String, firstName: String, lastName: String, completion: (success: Bool, message: String?) -> Void) {
        
        createAuthRecordAndLogin(email, password: password) { (success, message, uid) in
            if success {
                self.createUser(uid!, email: email, firstName: firstName, lastName: lastName, completion: completion)
            }
        }
    }

    // create new user
    
    private func createAuthRecordAndLogin(email: String, password: String, completion: (success: Bool, message: String?, uid: String?) -> Void) {
        
        ref.createUser(email, password: password, withCompletionBlock: { error in
            if (error != nil) {
                completion(success: false, message: error.description, uid: nil)
            } else {
                self.authUser(email, password: password) { (success, message, uid) in
                    if success {
                        completion(success: true, message: nil, uid: uid)
                    } else {
                        completion(success: false, message: message, uid: nil)
                    }
                }
            }
        })
    }

    // auth user
    
    private func authUser(email: String, password: String, completion: (success: Bool, message: String?, uid: String?) -> Void) {
       
        ref.authUser(email, password: password) { error, authData in
            if (error != nil) {
                completion(success: false, message: error.description, uid: nil)
            } else {
                self.currentUid = authData.uid
                completion(success: true, message: nil, uid: authData.uid)
            }
        }
    }
    
    
    // Create User Object on Firebase
    
    private func createUser(uid: String, email: String, firstName: String, lastName: String, completion: (success: Bool, message: String?) -> Void) {
        
        let firebaseUser = ["uid": uid, "email": email, "username": email, "firstName": firstName, "lastName": lastName]
        let usersRef = ref.childByAppendingPath(fbUsers)
        
        usersRef.childByAppendingPath(uid).setValue(firebaseUser, withCompletionBlock: { error, result in
            if error != nil {
                completion(success: false, message: error.description)
            } else {
                completion(success: true, message: nil)
            }
        })
    }
    
    // get user object
    
    func getCurrentUser(completion: (success: Bool, message: String?, user: User?) -> Void) {
        getUser(self.currentUid!, completion: completion)
    }
    
    
    // login user
    
    func loginUser(email: String, password: String, completion: (success: Bool, message: String?, uid: String?) -> Void) {
        authUser(email, password: password, completion: completion)
    }
    
    
    // get current team for current user
    
    func getTeamForCurrentUser(teamId: String, completion: (success: Bool, message: String?, team: Team?) -> Void) {
        
        let teamsRef = ref.childByAppendingPath(fbTeams).childByAppendingPath(teamId)
        
        teamsRef.observeEventType(.Value, withBlock: { result in
            
            if result != nil {
                
                let teamObject = result.value as! NSDictionary
                let teamObjectUsers = teamObject["users"] as! NSDictionary
                let userKeys = teamObjectUsers.allKeys as! [String]
   
                self.getTeamUsersForUsersAndTeam(userKeys, teamId: teamId) { (success, message, users) in
                    
                    let newTeam = Team(
                        id: (result.key as String),
                        teamName: (teamObject["teamName"] as! String),
                        teamChallengeName: (teamObject["teamChallengeName"] as! String),
                        endDate: teamObject["teamEndDate"] as! NSTimeInterval,
                        users: users!
                    )
                    
                    completion(success: true, message: nil, team: newTeam)
                    
                }
            }
        })
    }
        
    func getTeamUsersForUsersAndTeam(uids: [String], teamId: String, completion: (success: Bool, message: String?, teamUsers: [TeamUser]?) -> Void) {
        var teamUsers = [TeamUser]()
        var hasFailed = false
        
        for uid in uids {
            getUserForTeam(uid, teamId: teamId) { (success, message, teamUser) in
                if success {
                    teamUsers.append(teamUser!)
                    if teamUsers.count == uids.count {
                        completion(success: true, message: nil, teamUsers: teamUsers)
                    }
                } else if (!hasFailed) {
                    hasFailed = true
                    completion(success: false, message: message, teamUsers: nil)
                }
            }
        }
        
    }

    // get goal for some team on current user
    
    
    func getGoalForTeamForCurrentUser(teamId: String, completion: (success: Bool, message: String?, goal: Goal?) -> Void) {
        getGoalForTeamForUser(self.currentUid!, teamId: teamId, completion: completion)
    }
    
    
    func getGoalForTeamForUser(uid: String, teamId: String, completion: (success: Bool, message: String?, goal: Goal?) -> Void) {
        let goalsRef = ref.childByAppendingPath(fbGoal)
        let query = goalsRef.queryOrderedByChild("uid").queryEqualToValue(uid)
        
        query.observeEventType(.Value, withBlock: { goalResult in
            if goalResult != nil {
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
                        
                        let newGoal = Goal(goalId: goalId, isWeightGoal: isWeightGoal, startWeight: startWeight, endWeight: endWeight, currentWeight: currentWeight, achieveTitle: achieveTitle, isAchieved: isAchieved)
                        
                        completion(success: true, message: nil, goal: newGoal)
                    }
                }
            } else {
                completion(success: false, message: "couldn't get goal", goal: nil)
            }
        })
    }
    
    
    // MARK: Team
    
    // get users of a team
    
    func getUser(uid: String, completion: (success: Bool, message: String?, user: User?) -> Void) {
        
        let userRef = ref.childByAppendingPath(fbUsers).childByAppendingPath(uid)
        
        userRef.observeEventType(.Value, withBlock: { result in
            if result != nil {
                let userObject = result.value as! NSDictionary
                let newUser = User(uid: ((userObject["uid"]) as! String), email: ((userObject["email"]) as! String), currentTeam: ((userObject["currentTeam"]) as! String), firstName: ((userObject["firstName"]) as! String), lastName: ((userObject["lastName"]) as! String))
                completion(success: true, message: nil, user: newUser)
            } else {
                completion(success: false, message: "error retrieving user object", user: nil)
            }
        })
        
    }


    
    
    
    func getUserForTeam(uid: String, teamId: String, completion: (success: Bool, message: String?, teamUser: TeamUser?) -> Void) {
 
        getUser(uid) { (success, message, user) in
            if success {
                self.getGoalForTeamForUser(uid, teamId: teamId) { (success, message, goal) in
                    if success {
                        let newTeamUser = TeamUser(user: user, goal: goal)
                        completion(success: true, message: nil, teamUser: newTeamUser)
                    } else {
                        completion(success: false, message: message, teamUser: nil)
                    }
                }
            } else {
                completion(success: false, message: message, teamUser: nil)
            }
        }
    }


    
    
    
    
    
    
    // create team object
    
    
    // create goal object
    
//    func createGoal(goal: Goal, success: (Goal), failure: () -> Void) {
//
//        let newGoalRef = ref.childByAppendingPath("goals").childByAutoId()
//
//        // translator object > dictionary
//        
////        let dict: NSDictionary = translator.objecttodict(goal)
//        let dict = ["awesome": "awesome"]
//        
//        newGoalRef.setValue(dict, withCompletionBlock: { error, results in
//            if error != nil {
//                failure()
//            } else {
//                
////                var object: Goal = translator.dicttoobject(results as! NSDictionary)
//                var object: Goal? = Goal(startWeight: 2.0, endWeight: 1.0)
//                
//                if object != nil {
//                    failure()
//                } else {
//                    success(object)
//                }
//            }
//        })
//    }
//    
    
    
   
        
        
        
       
    
    
    
    
    
    
    
    
    // add goal update

    
    // add team to user
    
    
    // add user to team
    
    
    // create post
    
    
    // get posts
    
    
    
    
    
    
    
    
    
    
}