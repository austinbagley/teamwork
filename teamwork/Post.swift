//
//  Post.swift
//  teamwork
//
//  Created by Austin Bagley on 2/10/16.
//  Copyright © 2016 Austin Bagley. All rights reserved.
//

import Foundation


class Post {
    
    var postId: String?
    var postContent: String?
    var dateTime: NSDate?
    var user: User?
    
    var currentUser = CurrentUser.sharedInstance
    
    init(postContent: String, dateTime: NSDate, user: User) {
        
        self.postId = nil
        self.postContent = postContent
        self.dateTime = dateTime
        self.user = user
    }
    
    
    init(postId: String, postContent: String, dateTime: NSTimeInterval, uid: String, teamUsers: [TeamUser]) {
        
        self.postId = postId
        self.postContent = postContent
        self.dateTime = NSDate(timeIntervalSince1970: dateTime)
        
        let uid = uid
        let teamUsers = teamUsers

        for teamUser in teamUsers {
            let user = teamUser.user
            
            if user!.uid == uid {
                self.user = user
            }
        }
    }
    
    
}
