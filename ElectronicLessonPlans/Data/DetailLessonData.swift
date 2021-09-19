//
//  DetailLessonData.swift
//  ElectronicLessonPlans
//
//  Created by Chu Du on 13/07/2021.
//

import Foundation

class DetailLesson {
    var generalInfo:String?
    var activityOfTeacher:String?
    var activityOfStudent:String?
    var note:String?
    
    init(dictionary: [String: AnyObject]) {
        generalInfo = dictionary["general"] as? String
        activityOfTeacher = dictionary["activityOfTeacher"] as? String
        activityOfStudent = dictionary["activityOfStudent"] as? String
        note = dictionary["note"] as? String
    }
    
//    init() {
//        self.generalInfo = "Không có"
//        self.activityOfTeacher = "Không có"
//        self.activityOfStudent = "Không có"
//        self.note = "Không có"
//    }
//
//    init(generalInfo:String, activityOfTeacher:String, activityOfStudent:String, note:String) {
//        self.generalInfo = generalInfo
//        self.activityOfTeacher = activityOfTeacher
//        self.activityOfStudent = activityOfStudent
//        self.note = note
//    }
}

//let detaiLessonData:[DetailLesson] = [
//    DetailLesson(),
//    DetailLesson(generalInfo: "...", activityOfTeacher: "...", activityOfStudent: "...", note: "..."),
//    DetailLesson(),
//    DetailLesson(generalInfo: "...", activityOfTeacher: "...", activityOfStudent: "...", note: "..."),
//    DetailLesson()
//]
