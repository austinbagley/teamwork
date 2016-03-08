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
        
        let userRef = ref.childByAppendingPath(fbUsers).childByAppendingPath(self.currentUid)
        
        userRef.observeEventType(.Value, withBlock: { result in
            if result != nil {
                let userObject = result.value as! NSDictionary
                let newUser = User(uid: ((userObject["uid"]) as! String), email: ((userObject["email"]) as! String), currentTeam: ((userObject["currentTeam"]) as! String), firstName: ((userObject["firstName"]) as! String), lastName: ((userObject["lastName"]) as! String))
                completion(success: true, message: "successfully retrieved user object", user: newUser)
            } else {
                completion(success: false, message: "error retrieving user object", user: nil)
            }
        })
    }
    
    
    // login user
    
    func loginUser(email: String, password: String, completion: (success: Bool, message: String?, uid: String?) -> Void) {
        authUser(email, password: password, completion: completion)
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
    
    
    // view controller
    
    func onPressCreateGoalButton() {
        
        
        
    }
        
        
        
       
    
    
    
    
    
    
    
    
    // add goal update

    
    // add team to user
    
    
    // add user to team
    
    
    // create post
    
    
    // get posts
    
    
    
    
    
    
    
    
    
    
}