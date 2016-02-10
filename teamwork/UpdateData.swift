//
//  UpdateData.swift
//  teamwork
//
//  Created by Austin Bagley on 2/4/16.
//  Copyright © 2016 Austin Bagley. All rights reserved.
//

import Foundation
import Firebase

class UpdateData {
    
    // MARK: Properties
    
    let fb = FirebaseConstants.sharedInstance
    var baseRef: Firebase {
        get {
            return Firebase(url: fb.firebaseUrl)
        }
    }
    
    var currentUser = CurrentUser.sharedInstance
    
    // MARK: Actions
    
    
    func updateWeight(weight: Double, callBack: () -> Void) {
        print("update started")
        
        let currentGoalId = currentUser.currentGoal!.goalId!
        let priorWeight = currentUser.currentGoal!.currentWeight!
        let weightLossThisPeriod = Double(priorWeight) - weight
        let newCurrentWeight = [ "currentWeight" : (NSNumber(double: weight)) ]
        
        let goalRef = baseRef.childByAppendingPath(fb.firebaseGoals).childByAppendingPath(currentGoalId)
        let newUpdate = goalRef.childByAppendingPath("updates").childByAutoId()
        let currentDate = NSDate().timeIntervalSince1970 as NSNumber
        
        let newUpdateValue = [
            "weightLogged" : NSNumber(double: weight),
            "weightLossThisPeriod" : NSNumber(double: weightLossThisPeriod),
            "lastWeightLogged" : priorWeight,
            "currentDate" : currentDate
        ]
       
        print(newUpdateValue)
        
        goalRef.updateChildValues(newCurrentWeight, withCompletionBlock: {
            (error: NSError?, ref: Firebase!) in
            if (error != nil) {
                print("Data could not be saved")
            } else {
                
                newUpdate.setValue(newUpdateValue, withCompletionBlock: {
                    (error:NSError?, ref:Firebase!) in
                    if (error != nil) {
                        print("Data could not be saved.")
                    } else {
                        print("update created")
                        callBack()
                    }
                })
            }
        })
        
        
        
        
    }
    
    
    
    func createPost(content: String, callBack: () -> Void) {
        
        let postContent = content
        let user = currentUser.user!
        let team = currentUser.user!.currentTeam!
        let date = NSDate()
        
        let ref = self.baseRef
        let teamsRef = ref.childByAppendingPath(fb.firebaseTeams)
        let teamRef = teamsRef.childByAppendingPath(team)
        let teamPostRef = teamRef.childByAppendingPath("posts")
        let postRef = teamPostRef.childByAutoId()
        
        
        let post = Post(postContent: postContent, dateTime: date, user: user)
        
        let newPost = [ "postContent" : post.postContent!, "uid": post.user!.uid!, "dateTime" : (((post.dateTime?.timeIntervalSince1970)! as NSNumber))]
        
        
        postRef.setValue(newPost, withCompletionBlock: {
            (error:NSError?, ref:Firebase!) in
            if (error != nil) {
                print(error)
            } else {
                print("new post created with key: \(ref.key)")
                callBack()
                
            }
        
        })

    }
    
    
    
    
    
    
    
    
}
