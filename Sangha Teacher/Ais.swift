//
//  Ais.swift
//  Sangha Teacher
//
//  Created by Ezhil on 9/25/17.
//  Copyright © 2017 Sangha. All rights reserved.
//

import Foundation


public class Ais {
	public var _id: String? = ""
	public var eid: String! = ""
	public var aiType: String! = ""
	public var createdBy: String! = ""
	public var lastUpdateBy: String! = ""
	public var title: String! = ""
	public var stime: String! = ""
	public var etime: String! = ""
	public var organizationId: String! = ""
	public var summary : Summary?
	public var contentType: String! = ""
	public var desc: String! = ""
	public var richText: String! = ""
	public var deadline: String! = ""
	public var status: String! = ""
	public var deadlineMode: Int! = 0
	public var lastUpdateTime: String! = ""
	public var creationTime: String! = ""
	public var _deleted: String! = ""
	public var docType: String! = ""
	public var __v: Int! = 0
    


    public class func modelsFromDictionaryArray(array:[Dictionary<String, Any>]) -> [Ais]{
        
        var models:[Ais] = []
        for item in array
        {
            models.append(Ais(dictionary: item)!)
        }
        return models
    }


	required public init?(dictionary: Dictionary<String, Any>) {

		_id = dictionary["_id"] as? String ?? ""
		eid = dictionary["eid"] as? String ?? ""
		aiType = dictionary["aiType"] as? String ?? ""
		createdBy = dictionary["createdBy"] as? String ?? ""
		lastUpdateBy = dictionary["lastUpdateBy"] as? String ?? ""
		title = dictionary["title"] as? String ?? ""
		stime = dictionary["stime"] as? String ?? ""
		etime = dictionary["etime"] as? String ?? ""
		organizationId = dictionary["organizationId"] as? String ?? ""
		
		contentType = dictionary["contentType"] as? String ?? ""
		desc = dictionary["desc"] as? String ?? ""
		richText = dictionary["richText"] as? String ?? ""
		deadline = dictionary["deadline"] as? String ?? ""
        
        if let summaryDictionary = dictionary["summary"] as? Dictionary<String, Any>{
            
            summary = Summary(dictionary: summaryDictionary)
        }
		
        
        status = dictionary["status"] as? String ?? ""
		deadlineMode = dictionary["deadlineMode"] as? Int ?? 0
		lastUpdateTime = dictionary["lastUpdateTime"] as? String ?? ""
		creationTime = dictionary["creationTime"] as? String ?? ""
		_deleted = dictionary["_deleted"] as? String ?? ""
		docType = dictionary["docType"] as? String ?? ""
		__v = dictionary["__v"] as? Int ?? 0
	}
}
