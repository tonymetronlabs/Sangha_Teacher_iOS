//
//  GetAllClasses.swift
//  Sangha Teacher
//
//  Created by Ezhil on 06/10/17.
//  Copyright © 2017 Sangha. All rights reserved.
//

import UIKit

class ClassList: NSObject, Decodable {
    var status:Int?
    var classes:[Classes] = [Classes]()
}

class Classes : Decodable {
    var _id : String = ""
    var desc : String = ""
    var title : String = ""
    var studentsCount : Int = 0

    private enum codingkeyschange : String, CodingKey {
        case id = "_id"
    }
}
