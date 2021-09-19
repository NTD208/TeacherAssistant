//
//  AccountData.swift
//  ElectronicLessonPlans
//
//  Created by Chu Du on 13/07/2021.
//

import Foundation
//import FirebaseDatabase

struct Account {
    var email:String
    var password:String
}

var accountData:[Account] = [
    Account(email: "1", password: "1"),
    Account(email: "2", password: "2")
]

struct Teacher {
    var name:String
    var dob:String
    var level:String
    var classHeadTeacher:String
    var subject:String
}

var teacherData:[Teacher] = [
    Teacher(name: "Nguyễn Tiến Du", dob: "Aug 20, 2000", level: "Tiểu Học", classHeadTeacher: "5A4", subject: "Toán")
]
