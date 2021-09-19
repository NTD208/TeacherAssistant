//
//  Message.swift
//  ElectronicLessonPlans
//
//  Created by Chu Du on 10/08/2021.
//

import UIKit
import Firebase

class Message: NSObject {
    @objc var fromId: String?
    @objc var text: String?
    @objc var toId: String?
    @objc var timestamp: NSNumber?
    @objc var imageURL: String?
    @objc var imageHeight: NSNumber?
    @objc var imageWidth: NSNumber?
    
    func chatPartnerId() -> String? {
        return fromId == Auth.auth().currentUser?.uid ? toId : fromId
    }
    
    init (dictionary: [String: AnyObject]) {
        super.init()
        
        fromId = dictionary["fromId"] as? String
        timestamp = dictionary["timestamp"] as? NSNumber
        toId = dictionary["toId"] as? String
        text = dictionary["text"] as? String
        
        imageHeight = dictionary["imageHeight"] as? NSNumber
        imageURL = dictionary["imageURL"] as? String
        imageWidth = dictionary["imageWidth"] as? NSNumber
    }
}
