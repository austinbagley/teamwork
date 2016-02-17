//
//  TeamList.swift
//  teamwork
//
//  Created by Austin Bagley on 2/4/16.
//  Copyright © 2016 Austin Bagley. All rights reserved.
//

import Foundation


class TeamList {
    
    static let sharedInstance = TeamList()
    private init() {
    }
    
    deinit {}
    
    var teamList: [Team]?
    
}
