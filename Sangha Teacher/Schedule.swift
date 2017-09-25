//
//  Schedule.swift
//  Sangha Teacher
//
//  Created by Ezhil on 9/22/17.
//  Copyright © 2017 Sangha. All rights reserved.
//

import Foundation

public class Schedule {
    public var calendar: [EventCalendar] = []
    public var type: String! = ""
    
    public class func modelsFromDictionaryArray(array:[Dictionary<String, Any>]) -> [Schedule]{
        
        var models: [Schedule] = []
        for item in array{
            
            models.append(Schedule(dictionary: item)!)
        }
        return models
    }
    
    required public init?(dictionary: Dictionary<String, Any>) {
        
        if let calendarArray = dictionary["calendar"] as? [Dictionary<String, Any>]{
         
            calendar = EventCalendar.modelsFromDictionaryArray(array: calendarArray)
        }
        
        type = dictionary["type"] as? String ?? ""
    }
    
}
