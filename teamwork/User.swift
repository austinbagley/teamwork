//
//  User.swift
//  teamwork
//
//  Created by Austin Bagley on 2/2/16.
//  Copyright © 2016 Austin Bagley. All rights reserved.
//

import Foundation


class User {
    
    var uid: String?
    var pw: String?
    var email: String?
    var currentTeam: String?
    var firstName: String?
    var lastName: String?
    
    init(pw: String, email: String, firstName: String, lastName: String) {
        self.uid = nil
        self.pw = pw
        self.email = email
        self.currentTeam = nil
        self.firstName = firstName
        self.lastName = lastName
    }
    
    
    init(uid: String, email: String, currentTeam: String, firstName: String, lastName: String) {
        self.uid = uid
        self.pw = nil
        self.email = email
        self.currentTeam = currentTeam
        self.firstName = firstName
        self.lastName = lastName
    }
    
    init() {
        
    }
    
    
}

