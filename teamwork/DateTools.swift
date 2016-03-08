//
//  DateTools.swift
//  teamwork
//
//  Created by Austin Bagley on 2/22/16.
//  Copyright © 2016 Austin Bagley. All rights reserved.
//

import Foundation


class DateTools {
    
    
    static func convertDate(date: NSTimeInterval) -> String {
        let date = NSDate(timeIntervalSince1970: date)
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = .LongStyle
        let dateString = dateFormatter.stringFromDate(date)
        return dateString
    }
    
    static func daysToGo(teamEndDate: NSTimeInterval) -> String {
        
        let start = NSDate()
        let end = NSDate(timeIntervalSince1970: teamEndDate)
        let cal = NSCalendar.currentCalendar()
        let unit: NSCalendarUnit = NSCalendarUnit.Day
        let components = cal.components(unit, fromDate: start, toDate: end, options: .MatchFirst)
        let result = "\(components.day)"
        
        return result
    }
    
    
    
    
    
    
    
    
}
