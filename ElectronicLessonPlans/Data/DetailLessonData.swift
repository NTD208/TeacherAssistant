//
//  DetailLessonData.swift
//  ElectronicLessonPlans
//
//  Created by Chu Du on 13/07/2021.
//

import Foundation

class DetailLesson {
    var uuid:String?
    var generalInfo:String?
    var activityOfTeacher:String?
    var activityOfStudent:String?
    var note:String?
    
    init(dictionary: [String: AnyObject], id: String) {
        uuid = id
        generalInfo = dictionary["general"] as? String
        activityOfTeacher = dictionary["activityOfTeacher"] as? String
        activityOfStudent = dictionary["activityOfStudent"] as? String
        note = dictionary["note"] as? String
    }
}
