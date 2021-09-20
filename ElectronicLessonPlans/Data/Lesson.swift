//
//  Lesson.swift
//  ElectronicLessonPlans
//
//  Created by Chu Du on 12/07/2021.
//

import Foundation

class Lesson {
    var uid:String?
    var number:String?
    var title:String?
    var chapter:Int?
    
    init(dictionary: [String: AnyObject], id: String) {
        uid = id
        number = dictionary["number"] as? String
        title = dictionary["title"] as? String
        chapter = dictionary["chapter"] as? Int
    }
}
