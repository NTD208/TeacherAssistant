//
//  Subject.swift
//  ElectronicLessonPlans
//
//  Created by Chu Du on 10/07/2021.
//

import Foundation

struct Subject {
    var name:String?
    var num:Int?
    
    init(dictionary: [String: AnyObject], i: Int) {
        name = dictionary["subject"] as! String + " \(i)"
        num = i
    }
}
