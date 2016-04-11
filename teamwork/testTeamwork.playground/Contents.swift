//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"

print(str)


class Team {
    
    var teamName = "awesome"
    
    init(){
        
    }
    
}


class User {
    var user = "hi"
    
    init() {
        
    }
}


class TeamUser {
    
    var team: Team
    var user: User
    
    init(team: Team, user: User) {
        self.team = team
        self.user = user
    }
}


class Model {
    
    var teamUser = TeamUser(team: Team(), user: User())
    
    func print() {
    print(teamUser)
    }
    
}





