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
    
    // MARK: User
    

    // create new user
    
    func uidForNewUserFromEmail(email: String?, password: String?, completion: (success: Bool, message: String?) -> Void) {
        
        var email: String?
        var password: String?
        
        if email != nil && password != nil {
            email = email!
            password = password!
        } else {
            completion(success: false, message: "Please enter email and password")
        }
        
        ref.createUser(email, password: password, withCompletionBlock: { error in
            if (error != nil) {
                completion(success: false, message: "\(error)")
            } else {
                completion(success: true, message: "Successfully created new user")
            }
        })
    }

    // auth user
    
    
    func uidForExistingUser(email: String?, password: String?, completion: (success: Bool, message: String?, uid: String?) -> Void) {
        
        var uid: String?
        var email: String?
        var password: String?
        
        if email != nil && password != nil {
            email = email!
            password = password!
        } else {
            completion(success: false, message: "Please enter email and password", uid: nil)
        }
       
        ref.authUser(email, password: password) { error, authData in
            if (error != nil) {
                completion(success: false, message: "\(error)", uid: nil)
            } else {
                uid = authData.uid
                completion(success: true, message: "Successfully logged in", uid: uid)
            }
        }
    }
    
    
    // Create User Object on Firebase
    
    func createUser(uid: String?, email: String?, firstName: String?, lastName: String?, completion: (success: Bool, message: String?) -> Void) {
        
        var firebaseUser: [String: String]?
        var uid: String?
        let usersRef = ref.childByAppendingPath(fbUsers)
        
        if uid != nil && email != nil && firstName != nil && lastName != nil {
            firebaseUser = ["uid": uid!, "email": email!, "username": email!, "firstName": firstName!, "lastName": lastName!]
            uid = uid!
        }
        
        usersRef.childByAppendingPath(uid).setValue(firebaseUser, withCompletionBlock: { error, result in
            if error != nil {
                completion(success: false, message: "\(error)")
            } else {
                completion(success: true, message: "Successfully added user to database")
            }
        })
    }
    
    
    // get user object
    
    
    
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