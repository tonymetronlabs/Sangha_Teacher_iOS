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

    private enum CodingKee : String, CodingKey {
        case classObj = "class"
    }
}

struct Student : Decodable {
    var id : String = ""
    var firstName : String = ""
    var lastName : String = ""

    var parents : [Parent]?

    private enum CodingKeyss : String, CodingKey {
        case firstName = "fname",
        lastName = "lname",
        id = "_id"
    }
}

struct Parent : Decodable {
    var id : String = ""
    var email : String = ""
    var firstName : String = ""
    var lastName : String = ""
    var image : String = ""
    var channel : String = ""
    var mobile : String = ""
    private enum CodingKeyss : String, CodingKey {
        case firstName = "fname",
        lastName = "lname",
        id = "_id"
    }
}

struct Summary : Decodable {
    var count : [Channel]?
}

struct Channel : Decodable {
    var channel : String = ""
    var parentsCount : Int = 0
    var studentsCount : Int = 0
}
