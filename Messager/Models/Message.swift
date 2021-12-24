//
//  Message.swift
//  Messager
//
//  Created by Сергей on 14.12.2021.
//

import Foundation
import UIKit
import FirebaseFirestore

struct Message: Hashable {
    
    let content: String
    let senderId: String
    let senderUsername: String
    var sentDate: Date
    let id: String?
    
    init(user: MessageUser, content: String) {
        self.content = content
        self.senderId = user.id
        self.senderUsername = user.username
        self.sentDate = Date()
        id = nil
    }
    
    init?(document: QueryDocumentSnapshot) {
        let data = document.data()
        guard let sentDate = data["created"] as? Timestamp else {return nil}
        guard let senderId = data["senderId"] as? String else {return nil}
        guard let senderName = data["senderName"] as? String else {return nil}
        guard let content = data["content"] as? String else {return nil}
        
        self.id = document.documentID
        self.sentDate = sentDate.dateValue()
        self.senderId = senderId
        self.senderUsername = senderName
        self.content = content
    }
    
    var represantation: [String: Any] {
        let rep: [String: Any] = [
            "created": sentDate,
            "content": content,
            "senderName": senderUsername,
            "senderId": senderId
        ]
        return rep
    }
    
    static func == (lhs: Message, rhs: Message) -> Bool {
        return lhs.id == rhs.id
    }

}
