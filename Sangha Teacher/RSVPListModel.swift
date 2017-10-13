//
//  RSVPListModel.swift
//  Sangha Teacher
//
//  Created by Ashfauck on 10/11/17.
//  Copyright © 2017 Sangha. All rights reserved.
//

import UIKit

class RSVPListModel: Decodable {

    var status:Int?
    var ai:AiModel?
    
}

class AiModel:Decodable  {
    
    var _id:String?
    var aiType:AiType?
    var title:String?
    var stime:String?
    var etime:String?
    var desc:String?
    var deadline:String?
    var capacity:Int?
    var maxpr:Int?
    var responses:Responses?
    
}

class Responses: Decodable
{
    var accepts:[AcceptsResponses?]?
    var rejects:[RejectedResponses?]?
    var pending:[PendingResponses?]?
}

class AcceptsResponses: Decodable
{
    var luTime:String?
    var parentName:String?
    var studentName:String?
    var guestsCount:Int?
}

class RejectedResponses: Decodable
{
    var studentName:String?
}

class PendingResponses: Decodable
{
    var studentName:String?
}








