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
    
    // MARK: Properties
    
    let fb = FirebaseConstants.sharedInstance
    var ref: Firebase {
        get {
            return Firebase(url: fb.firebaseUrl)
        }
    }
    
    
    // MARK: User
    
    
    // create new user
    
    func uidForNewUserFromEmail(email: String, pw: String) -> (uid: String, success: Bool) {
        
        var success: Bool?
        var uid: String?
        
        ref.createUser(email, password: pw, withValueCompletionBlock: { error, result in
            if (error != nil) {
                print(error)
                success = false
            } else if result != nil {
                success = true
                uid = result["uid"] as? String
            } else {
                uid = ""
            }
        })
        return(uid!, success!)
    }
    

    // auth user
    
    
    // create user object
    
    
    // get user object
    
    
    // create team object
    
    
    // create goal object
    
    func createGoal(goal: Goal, success: (Goal), failure: () -> Void) {
        
        let newGoalRef = ref.childByAppendingPath("goals").childByAutoId()
        
        // translator object > dictionary
        
//        let dict: NSDictionary = translator.objecttodict(goal)
        let dict = ["awesome": "awesome"]
        
        newGoalRef.setValue(dict, withCompletionBlock: { error, results in
            if error != nil {
                failure()
            } else {
                
//                var object: Goal = translator.dicttoobject(results as! NSDictionary)
                var object: Goal? = Goal(startWeight: 2.0, endWeight: 1.0)
                
                if object != nil {
                    failure()
                } else {
                    success(object)
                }
            }
        })
    }
    
    
    
    // view controller
    
    func onPressCreateGoalButton() {
        
        
        
    }
        
        
        
       
    
    
    
    
    
    
    
    
    // add goal update

    
    // add team to user
    
    
    // add user to team
    
    
    // create post
    
    
    // get posts
    
    
    
    
    
    
    
    
    
    
}