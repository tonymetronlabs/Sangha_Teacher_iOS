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
        public var _id: String = ""
        public var title: String = ""
        public var desc: String = ""
        public var owner: String = ""
        public var stime: String = ""
        public var etime: String = ""
        public var organizationId: String = ""
        public var organizationName: String = ""
        public var docSubType: String = ""
        public var actionItems : [String] = []

        public var location : Location?
        public var schedule: Schedule?
        public var ais: [Ais]?
        public var computedSchedule: ComputedSchedule?
        public var attachments : [Attachment]?
        public var members : [Member]?
        public var klasses : [Klasses]?

        private enum key : String, CodingKey {
        case id = "_id"
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
        case contentType = "content-type"
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

    private enum ChangeOfKeys : String, CodingKey {
        case id = "_id"
    }
}

struct Ais : Decodable {
    public var id : String?
    public var eid : String?
    public var aiType : String?
    public var createdBy : String?
    public var total : Int?
    public var acceptCount : Int?

    private enum codingKey : String, CodingKey {
        case id = "_id"
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

    private enum keys : String,CodingKey {
        case id = "_id"
    }
 }
