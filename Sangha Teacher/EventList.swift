//
//  NowForOrg.swift
//  Sangha Teacher
//
//  Created by Ezhil on 06/10/17.
//  Copyright © 2017 Sangha. All rights reserved.
//

import UIKit

class EventList : Decodable {
    var status : Int?
    var events : [Event] = []
    var unreadMsgCounts : UnreadMsgCount = UnreadMsgCount()
    var connectedAccounts : [ConnectedAccounts] = [ConnectedAccounts]()
    var notifications: [Notification] = [Notification]()
}

// MARK: - Event Struct

class Event: Decodable {
        var id: String = ""
        var title: String = ""
        var desc: String = ""
        var owner: String = ""
        var startTime: String = ""
        var endTime: String = ""
        var organizationId: String = ""
        var organizationName: String = ""
        var docSubType: String? = ""
        var actionItems : [String] = []

        var location : Location?
        var schedule: Schedule?
        var ais: [Ais]?
        var computedSchedule: ComputedSchedule?
        var attachments : [Attachment]?
        var members : [Member]?
        var klasses : [Klasses]?

        private enum CodingKeys : String, CodingKey {
            case id = "_id", title, desc, owner, startTime = "stime", endTime = "etime", organizationId, organizationName, docSubType, actionItems, location, schedule, ais, computedSchedule, attachments, members, klasses
    }
}

class Location : Decodable {
    var address : String = ""
}

struct Schedule : Decodable {
    public var calendar : [ScheduleCalendar]?
    public var type : String?
}

struct Attachment : Decodable {
    public var name : String?
    public var contentType : String?
    public var size : Int?
    public var url : String?
    public var resizeUrl : String?
    public var lastUpdateTime : String?
    public var awsInfo : AwsInfo?

    private enum keys : String, CodingKey {
        case contentType = "content-type", name, size, url, resizeUrl, lastUpdateTime, awsInfo
    }
}

struct AwsInfo : Decodable {
    public var bucket : String?
    public var endPoint : String?
    public var key : String?
}

struct Member : Decodable {
    public var id : String?
    public var inherited : Bool?
    public var status : String?
    public var role : String?
    public var idType : String?
}

struct Klasses : Decodable {
    public var id : String?
    public var title : String?
    public var desc : String?
    public var owner : String?
    public var organizationId : String?

    private enum CodingKeys : String, CodingKey {
        case id = "_id", title, desc, owner, organizationId
    }
}

struct Ais : Decodable {
    public var _id : String?
    public var eid : String?
    public var aiType : AiType?
    public var createdBy : String?
    public var total : Int?
    public var acceptCount : Int?

    private enum CodingKeys : String, CodingKey {
        case id = "_id", eid, aiType, createdBy, total, acceptCount
    }
}

struct ComputedSchedule : Decodable {
    public var coeType : String?
    public var calendar : [ScheduleCalendar]?
    public var type : String?
}

struct ScheduleCalendar : Decodable {
    public var date : String?
    public var startTime : String?
    public var endTime : String?
    public var startDate : String?
    public var endDate : String?
}

class DateAndEvent {
    var date: Date = Date()
    var event: Event = Event()

    required public init?(with date: Date, events: Event) {
        self.date = date
        self.event = events
    }
}

//MARK: - Notifications Struct

struct Notification : Decodable {
    var id : String?
    var message : String?
}

struct UnreadMsgCount : Decodable {
    var messagesCount : Int?
    var chatsCount : Int?
}

struct ConnectedAccounts : Decodable {
    var id : String?
    var organizationId : String?
    var classId : String?
    var stripeAccountId : String?
    var businessName : String?
    var displayName : String?
    var stripeEmail : String?

    private enum CodingKeys : String,CodingKey {
        case id = "_id", organizationId, classId, stripeAccountId, businessName, displayName, stripeEmail
    }
 }
