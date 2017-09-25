//
//  Summary.swift
//  Sangha Teacher
//
//  Created by Ezhil on 9/25/17.
//  Copyright © 2017 Sangha. All rights reserved.
//

import Foundation

public class Summary {
	public var acceptCount: Int! = 0
	public var pendingCount: Int! = 0
	public var respondentCount: Int! = 0
    public var rcap: Int! = 0


    public class func modelsFromDictionaryArray(array:[Dictionary<String, Any>]) -> [Summary]{
        
        var models:[Summary] = []
        for item in array
        {
            models.append(Summary(dictionary: item)!)
        }
        return models
    }

	required public init?(dictionary: Dictionary<String, Any>) {

		acceptCount = dictionary["acceptCount"] as? Int ?? 0
		pendingCount = dictionary["pendingCount"] as? Int ?? 0
		respondentCount = dictionary["respondentCount"] as? Int ?? 0
        rcap = dictionary["rcap"] as? Int ?? 0
		
	}

}
