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
    var uid: String?
    var firstName: String?
    var lastName: String?
    
    init(postContent: String, dateTime: NSDate, uid: String, firstName: String?, lastName: String?) {
        
        self.postId = nil
        self.postContent = postContent
        self.dateTime = dateTime
        self.uid = uid
        self.firstName = firstName
        self.lastName = lastName
    }
    
    
    init(postContent: String, dateTime: NSTimeInterval, uid: String, firstName: String?, lastName: String?) {
        
        self.postId = ""
        self.postContent = postContent
        self.dateTime = NSDate(timeIntervalSince1970: dateTime)
        self.uid = uid
        self.firstName = firstName
        self.lastName = lastName
    }
    
    
}
