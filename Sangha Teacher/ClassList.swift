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
    var id : String = ""
    var desc : String = ""
    var title : String = ""
    var studentsCount : Int = 0

    var parentsCount : Int?
    var students : [Student]?
    var summary : Summary?

    private enum CodingKeys : String, CodingKey {
        case id = "_id", desc, title, studentsCount, parentsCount, summary, students
    }
}
