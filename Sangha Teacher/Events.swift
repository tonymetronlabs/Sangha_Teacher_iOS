//
//  Events.swift
//  Sangha Teacher
//
//  Created by Ezhil on 9/22/17.
//  Copyright © 2017 Sangha. All rights reserved.
//

import Foundation

public class Events {
    public var _id: String! = ""
    public var title: String! = ""
    public var desc: String! = ""
    public var owner: String! = ""
    public var schedule: Schedule?
    public var stime: String! = ""
    public var etime: String! = ""
    public var organizationId: String! = ""
    public var organizationName: String! = ""
    public var docSubType: String! = ""
    public var status: String! = ""
    public var computedSchedule: ComputedSchedule?
    public var ais: [Ais] = []
    
    public class func modelsFromDictionaryArray(array:[Dictionary<String, Any>]) -> [Events]{
        
        var models:[Events] = []
        
        for item in array{
            
            models.append(Events(dictionary: item)!)
        }
        return models
    }
    
    required public init?(dictionary: Dictionary<String, Any>) {
        
        _id = dictionary["_id"] as? String ?? ""
        title = dictionary["title"] as? String ?? ""
        desc = dictionary["desc"] as? String ?? ""
        owner = dictionary["owner"] as? String ?? ""
        
        if let scheduleDictionary = dictionary["schedule"] as? Dictionary<String, Any>{
            
            schedule = Schedule(dictionary: scheduleDictionary)
        }
        
        stime = dictionary["stime"] as? String ?? ""
        etime = dictionary["etime"] as? String ?? ""
        organizationId = dictionary["organizationId"] as? String ?? ""
        organizationName = dictionary["organizationName"] as? String ?? ""
        docSubType = dictionary["docSubType"] as? String ?? ""
        status = dictionary["status"] as? String ?? ""
        
        if let computedScheduleDictionary = dictionary["computedSchedule"] as? Dictionary<String, Any>{
            
            computedSchedule = ComputedSchedule(dictionary: computedScheduleDictionary)
        }
        
        if let aisValue = dictionary["ais"] as? [Dictionary<String, Any>]{
            
            ais = Ais.modelsFromDictionaryArray(array: aisValue)
        }
        
    }
}
