//
//  PaymentListModel.swift
//  Sangha Teacher
//
//  Created by Ashfauck on 10/13/17.
//  Copyright © 2017 Sangha. All rights reserved.
//

import UIKit

class PaymentListModel: Decodable
{
   var status:Int?
    var ai:paymentAi?
}

class paymentAi: Decodable
{
    var _id:String?
    var aiType:AiType?
    var title:String?
    var stime:String?
    var etime:String?
    var desc:String?
    var amount:Int?
    var currency:String?
    var tabType:String?
    var depAcct:String?
    var responses:paymentResponses?
}

class paymentResponses : Decodable {
    var accepts:PaymentAcceptsResponses?
    var pending:PendingResponses?
}

class PaymentAcceptsResponses:Decodable
{
    var luTime:String?
    var parentName:String?
    var studentName:String?
    var amount:Int?
    var currency:String?
}
