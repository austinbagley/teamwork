//
//  LogIn.swift
//  teamwork
//
//  Created by Austin Bagley on 2/8/16.
//  Copyright © 2016 Austin Bagley. All rights reserved.
//

import Foundation
import Firebase

class LogIn {
    
    var ref = Firebase(url: FirebaseConstants.sharedInstance.firebaseUrl)
    
    ref.authUser("jenny@example.com", password: "correcthorsebatterystaple") {
    error, authData in
    if error != nil {
    // an error occured while attempting login
    } else {
    // user is logged in, check authData for data
    }
    }
    
    
    
}
