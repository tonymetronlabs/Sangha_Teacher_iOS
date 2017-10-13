//
//  VolunteerListModel.swift
//  Sangha Teacher
//
//  Created by Ashfauck on 10/12/17.
//  Copyright © 2017 Sangha. All rights reserved.
//

import UIKit

class VolunteerListModel: Decodable
{
    var status:Int?
    var ai:AiVolunteerModel?
}

class AiVolunteerModel:Decodable
{
    var _id:String?
    var aiType:AiType?
    var title:String?
    var stime:String?
    var etime:String?
    var desc:String?
    var tasks:[TaskListModel]?
}

class TaskListModel: Decodable
{
    var task:String?
    var capacity:Int?
    var desc:String?
    var title:String?
    var responses:[VolunteerResponses]?
    var isCollapsed:Bool? = false
    
    init(isCollapsed:Bool)
    {
        self.isCollapsed = false
    }
}

class VolunteerResponses: Decodable
{
    var luTime:String?
    var parentName:String?
    var studentName:String?
}



