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
            // don't include current user in team users
            if uid != self.currentUid {
                getUserForTeam(uid, teamId: teamId) { (success, message, teamUser) in
                    if success {
                        teamUsers.append(teamUser!)
                        if teamUsers.count == (uids.count - 1) {
                            completion(success: true, message: nil, teamUsers: teamUsers)
                        }
                    } else if (!hasFailed) {
                        hasFailed = true
                        completion(success: false, message: message, teamUsers: nil)
                    }
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
            if goalResult.exists() {
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
    
    // update user
    
    func updateUserEmailAndName(email: String, firstName: String, lastName: String) {
        
        let usersRef = ref.childByAppendingPath(fbUsers)
        let userRef = usersRef.childByAppendingPath(currentUid)
        let newData = [
            "email" : "\(email)",
            "firstName" : "\(firstName)",
            "lastName" : "\(lastName)"
        ]
        userRef.updateChildValues(newData)
    }
    
    func switchUserTeam(teamId: String) {
        let usersRef = ref.childByAppendingPath(fbUsers)
        let userRef = usersRef.childByAppendingPath(currentUid)
        let newData = [ "currentTeam" : "\(teamId)"]
        userRef.updateChildValues(newData)
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
    
    func createAndAddUserToTeam(teamName: String!, teamChallengeName: String!, teamPassword: String!, endDate: NSDate!, completion: (success: Bool, message: String?) -> Void) {
        
        let team = Team(teamName: teamName, teamChallengeName: teamChallengeName, teamPassword: teamPassword, endDate: endDate!)
        
        let teamRef = ref.childByAppendingPath(fbTeams)
        let endDateInterval = team.teamEndDate
        let uid = self.currentUid!
        let firebaseTeam = ["teamName": team.teamName!, "teamChallengeName" : team.teamChallengeName!, "teamEndDate" : endDateInterval!, "users": [uid : "true"] ]
        
        teamRef.childByAutoId().setValue(firebaseTeam, withCompletionBlock: { (error:NSError?, ref:Firebase!) in
            if (error != nil) {
                completion(success: false, message: error?.description)
            } else {
                let newTeamId = ref.key
                self.addTeamToCurrentUser(newTeamId, completion: completion)
            }
        })
    }

    // add user to team
    
    func addCurrentUserToTeam(teamId: String?, completion: (success: Bool, message: String?) -> Void) {
    }
    
    // add team to user
    
    func addTeamToCurrentUser(teamId: String?, completion: (success: Bool, message: String?) -> Void) {
        
        let usersRef = ref.childByAppendingPath(fbUsers).childByAppendingPath(self.currentUid)
        let newValue = [ teamId! : "true" ]
        
        usersRef.childByAppendingPath("teams").setValue(newValue, withCompletionBlock : { (error: NSError?, ref: Firebase!) in
            if (error != nil) {
                completion(success: false, message: error?.description)
            } else {
                self.setCurrentTeamForCurrentUser(teamId, completion: completion)
            }
        })
    }
    
    // set current team
    
    func setCurrentTeamForCurrentUser(teamId: String?, completion: (success: Bool, message: String?) -> Void) {
        let usersRef = ref.childByAppendingPath(fbUsers).childByAppendingPath(self.currentUid)
        let newValue = [ "currentTeam" : teamId! ]
        usersRef.updateChildValues(newValue, withCompletionBlock: { (error: NSError?, ref: Firebase!) in
            if error != nil {
                completion(success: false, message: error?.description)
            } else {
                completion(success: true, message: nil)
            }
        })
    }
    
    // get all teams
    
    func getTeamNamesForCurrentUser(completion: (success: Bool, message: String?, teams: [Team]?) -> Void) {
        let teamsRef = ref.childByAppendingPath(fbTeams)

        self.getTeamIdsForCurrentUser() { (success, message, teamIds) in
            if success {
                let teamCount = teamIds!.count
                var teamsArray = [Team]()
                for teamId in teamIds! {
                    let teamRef = teamsRef.childByAppendingPath(teamId)
                    teamRef.observeSingleEventOfType(.Value, withBlock: { snapshot in
                        if snapshot.exists() {
                            let teams = snapshot.value as! NSDictionary
                            let fbTeam =
                                Team(
                                    id: (teamId),
                                    teamName: (teams["teamName"] as! String),
                                    teamChallengeName: (teams["teamChallengeName"] as! String),
                                    endDate: (teams["teamEndDate"] as! NSTimeInterval),
                                    users: [TeamUser]()
                            )
                            teamsArray.append(fbTeam)
                            
                            if teamsArray.count == teamCount {
                                print(teamsArray.count)
                                completion(success: true, message: nil, teams: teamsArray)
                            }
                            
                        }
                    })
                }
            } else {
                completion(success: false, message: message, teams: nil)
            }
        }
    }
    
    private func getTeamIdsForCurrentUser(completion: (success: Bool, message: String?, teamIds: [String]?) -> Void) {
        let userRef = ref.childByAppendingPath(fbUsers).childByAppendingPath(currentUid!).childByAppendingPath("teams")
        var teamIds = [String]()

        userRef.observeSingleEventOfType(.Value, withBlock: { snapshot in
            if snapshot.exists() {
                let teams = snapshot.value as! NSDictionary
                
                for (id, _) in teams {
                    let teamId = id as! String
                    teamIds.append(teamId)
                }
                
                completion(success: true, message: nil, teamIds: teamIds)
            } else {
                completion(success: false, message: "failed to generate team ids", teamIds: nil)
            }
        })
        
    }
    
    
    // get team names
    
    func getTeamNames(completion: (success: Bool, message: String?, teams: [Team]?) -> Void) {
        
        let teamRef = ref.childByAppendingPath(fbTeams)
        var teamsArray = [Team]()
        
        let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
        dispatch_async(dispatch_get_global_queue(priority, 0)) {
            
            teamRef.observeSingleEventOfType(.Value, withBlock:  { snapshot in
                if snapshot.exists() {
                    let teams = snapshot.value as! NSDictionary
                    
                    for (id, teams) in teams {
                        let fbTeam =
                            Team(
                                id: (id as! String),
                                teamName: (teams["teamName"] as! String),
                                teamChallengeName: (teams["teamChallengeName"] as! String),
                                endDate: (teams["teamEndDate"] as! NSTimeInterval),
                                users: [TeamUser]()
                        )
                        teamsArray.append(fbTeam)
                    }
                    
                    dispatch_async(dispatch_get_main_queue()) {
                        completion(success: true, message: nil, teams: teamsArray)
                    }
                    
                } else {
                    completion(success: false, message: "Failed to generate Team List, please Create New Team", teams: [Team]())
                }
            })
        }
    }


    
    // MARK: Goals
    
    // create goal for current user
    
    func createWeightGoalForCurrentUser(startWeight: Double, endWeight: Double, completion: (success: Bool, message: String?) -> Void) {
        getCurrentUser() { (success, message, user) in
            if success {
                self.createWeightGoalForUser(user!, startWeight: startWeight, endWeight: endWeight, completion: completion)
            } else {
                completion(success: false, message: message)
            }
        }
    }
    
    private func createWeightGoalForUser(user: User, startWeight: Double, endWeight: Double, completion: (success: Bool, message: String?) -> Void) {
        
        let goalRef = ref.childByAppendingPath(fbGoal)
        let weightGoal = Goal(startWeight: startWeight, endWeight: endWeight)
        let firebaseGoal =
            [
                "uid":(user.uid)! as String,
                "teamId": (user.currentTeam)! as String,
                "isWeightGoal": "true" as String,
                "startWeight": weightGoal.startWeight! as NSNumber,
                "endWeight" : weightGoal.endWeight! as NSNumber,
                "totalWeightLoss": weightGoal.totalWeightLoss! as NSNumber,
                "currentWeight" : weightGoal.currentWeight! as NSNumber,
                "achieveTitle": "",
                "isAchieved": "false"
            ]
        
        goalRef.childByAutoId().setValue(firebaseGoal, withCompletionBlock:  { (error: NSError?, ref: Firebase!) in
            if (error != nil) {
                completion(success: false, message: error?.description)
            } else {
                completion(success: true, message: nil)
            }
        })
    }
    
    // add goal update
    
    func updateWeight(goalId: String, currentWeight: Double, priorWeight: Double, completion: (success: Bool, message: String?) -> Void) {
        
        let weightLossThisPeriod = Double(priorWeight) - currentWeight
        let newCurrentWeight = [ "currentWeight" : (NSNumber(double: currentWeight)) ]
        
        let goalRef = ref.childByAppendingPath(fbGoal).childByAppendingPath(goalId)
        let newUpdate = goalRef.childByAppendingPath("updates").childByAutoId()
        let currentDate = NSDate().timeIntervalSince1970 as NSNumber
        
        let newUpdateValue = [
            "weightLogged" : NSNumber(double: currentWeight),
            "weightLossThisPeriod" : NSNumber(double: weightLossThisPeriod),
            "lastWeightLogged" : priorWeight,
            "currentDate" : currentDate
        ]
        
        goalRef.updateChildValues(newCurrentWeight, withCompletionBlock: { (error: NSError?, ref: Firebase!) in
            if (error != nil) {
                completion(success: false, message: error!.description)
            } else {
                newUpdate.setValue(newUpdateValue, withCompletionBlock: { (error:NSError?, ref:Firebase!) in
                    if (error != nil) {
                        completion(success: false, message: error!.description)
                    } else {
                        completion(success: true, message: nil)
                    }
                })
            }
        })
    }
    
    // add team to user
    
    
    // add user to team
    
    
    
    // change (update) goal
    
    func changeWeightGoal(goalId: String, startWeight: Double, newEndWeight: Double) {
        
        let goalsRef = ref.childByAppendingPath(fbGoal)
        let goalRef = goalsRef.childByAppendingPath(goalId)
        let newTotalWeightLoss = startWeight - newEndWeight
        
        let newData = [
            "endWeight" : "\(newEndWeight)",
            "totalWeightLoss" : "\(newTotalWeightLoss)"
        ]
        
        goalRef.updateChildValues(newData)
    
    }
    
    
    
    // MARK: Posts
    
    
    // create post
    
    func createPostForCurrentUser(postContent: String, completion: (success: Bool, message: String?) -> Void) {
        
        getCurrentUser() { (success, message, user) in
            if success {
                self.createPostForUser(user!, postContent: postContent, completion: completion)
            } else {
                completion(success: false, message: message)
            }
        }
        
    }
    
    
    private func createPostForUser(user: User, postContent: String, completion: (success: Bool, message: String?) -> Void) {
        
        let postsRef = ref.childByAppendingPath(fbTeams).childByAppendingPath(user.currentTeam!).childByAppendingPath("posts")
        let postRef = postsRef.childByAutoId()
        
        let post = Post(postContent: postContent, dateTime: NSDate(), uid: user.uid!, firstName: user.firstName!, lastName: user.lastName!)
        let newPost = [ "postContent": post.postContent!, "uid": post.uid!, "dateTime": (((post.dateTime?.timeIntervalSince1970)! as NSNumber)), "firstName": post.firstName!, "lastName": post.lastName!]
        
        postRef.setValue(newPost, withCompletionBlock: { (error: NSError?, ref: Firebase!) in
            if (error != nil) {
                completion(success: false, message: error?.description)
            } else {
                completion(success: true, message: nil)
            }
        })
    }
    
    
    // get posts
    
    func getPostsForCurrentTeam(completion: (success: Bool, message: String?, posts: [Post]?) -> Void) {
        
        getCurrentUser() { (success, message, user) in
            if success {
                self.getPostsForTeam(user!.currentTeam!, completion: completion)
            } else {
                completion(success: false, message: message, posts: [Post]())
            }
        }
    }
    
    
    private func getPostsForTeam(teamId: String, completion: (success: Bool, message: String?, posts: [Post]?) -> Void) {
        
        let postsRef = ref.childByAppendingPath(fbTeams).childByAppendingPath(teamId).childByAppendingPath("posts")
        var posts = [Post]()
        
        postsRef.observeEventType(.Value, withBlock: { snapshot in
            if !snapshot.exists() {
                completion(success: false, message: "error getting posts", posts: posts)
            } else {
                let results = snapshot.value as! NSDictionary
                
                for (_, post) in results {
                    let interval = post["dateTime"] as! NSTimeInterval
                    let postContent = post["postContent"] as! String
                    let uid = post["uid"] as! String
                    let firstName = post["firstName"] as! String
                    let lastName = post["lastName"] as! String
                    
                    let newPost = Post(postContent: postContent, dateTime: interval, uid: uid, firstName: firstName, lastName: lastName)
                    
                    posts.append(newPost)
                    if posts.count == results.count {
                        completion(success: true, message: nil, posts: posts)
                    }
                }
            }
        })
    }
    
    
    
    
    
    
    
    
    
}