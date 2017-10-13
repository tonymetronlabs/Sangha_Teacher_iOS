//
//  ClassDetail.swift
//  Sangha Teacher
//
//  Created by Balaji on 10/10/17.
//  Copyright © 2017 Sangha. All rights reserved.
//

import UIKit

class ClassDetail: Decodable {

    var status : Int?
    var classObj : Classes?

    private enum CodingKeys : String, CodingKey {
        case classObj = "class", status
    }
}

struct Student : Decodable {
    var id : String = ""
    var firstName : String = ""
    var lastName : String = ""
    var parents : [Parent]?

    private enum CodingKeys : String, CodingKey {
        case firstName = "fname", lastName = "lname", id = "_id", parents
    }
}

struct Parent : Decodable {
    var id : String?
    var firstName : String?
    var lastName : String?
    var email : String?
    var channel : ChannelType?
    var image : String?
    var mobile : String?

    private enum CodingKeys : String, CodingKey {
        case firstName = "fname",lastName = "lname",id = "_id", email, channel, image, mobile
    }
}

struct Summary : Decodable {
    var counts : [Channel]?
}

struct Channel : Decodable {
    var channel : ChannelType?
    var parentsCount : Int = 0
    var studentsCount : Int = 0
}

enum ChannelType : String, Decodable {
    case mobile = "mobile"
    case app = "app"
    case landline = "landline"
    case email = "email"

    var image : UIImage {
        switch self {
        case .mobile:
            return #imageLiteral(resourceName: "mobile")
        case .app:
            return #imageLiteral(resourceName: "chat-1")
        case .email:
            return #imageLiteral(resourceName: "mail")
        case .landline:
            return #imageLiteral(resourceName: "call")
        default:
            return #imageLiteral(resourceName: "logo")
        }
    }
}
