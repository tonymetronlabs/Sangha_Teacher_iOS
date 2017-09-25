//
//  Calendar.swift
//  Sangha Teacher
//
//  Created by Ezhil on 9/22/17.
//  Copyright © 2017 Sangha. All rights reserved.
//

import Foundation

public class EventCalendar {
    public var date: String! = ""
    public var startTime: String! = ""
    public var endTime: String! = ""
    
    public class func modelsFromDictionaryArray(array:[Dictionary<String, Any>]) -> [EventCalendar]{
        
        var models:[EventCalendar] = []
        
        for item in array{
            
            models.append(EventCalendar(dictionary: item)!)
        }
        return models
    }
    
    required public init?(dictionary: Dictionary<String, Any>) {
        
        date = dictionary["date"] as? String ?? ""
        startTime = dictionary["startTime"] as? String ?? ""
        endTime = dictionary["endTime"] as? String ?? ""
    }    
}
