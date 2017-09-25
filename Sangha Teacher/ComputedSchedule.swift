//
//  ComputedSchedule.swift
//  Sangha Teacher
//
//  Created by Ezhil on 9/22/17.
//  Copyright © 2017 Sangha. All rights reserved.
//

import Foundation

public class ComputedSchedule {
    public var coeType: String! = ""
    public var calendar: [EventCalendar] = []
    public var type: String! = ""
    
    public class func modelsFromDictionaryArray(array:[Dictionary<String, Any>]) -> [ComputedSchedule]{
        
        var models:[ComputedSchedule] = []
        
        for item in array{
            
            models.append(ComputedSchedule(dictionary: item)!)
        }
        return models
    }
    

    required public init?(dictionary: Dictionary<String, Any>) {
        
        coeType = dictionary["coeType"] as? String ?? ""
        
        if let calendarArray = dictionary["calendar"] as? [Dictionary<String, Any>]{
            
            calendar = EventCalendar.modelsFromDictionaryArray(array: calendarArray)
            
        }
        
        type = dictionary["type"] as? String ?? ""
    }
}
