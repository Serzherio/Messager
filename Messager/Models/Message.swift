//
//  Message.swift
//  Messager
//
//  Created by Сергей on 14.12.2021.
//

import Foundation
import UIKit
import FirebaseFirestore
import MessageKit

struct Message: Hashable, MessageType {
    

    let content: String
    var sender: SenderType
    var sentDate: Date
    let id: String?
    
    var messageId: String {
        return id ?? UUID().uuidString
    }
    
    var kind: MessageKind {
        return .text(content)
    }
    
    
    init(user: MessageUser, content: String) {
        self.content = content
        sender = Sender(id: user.id, displayName: user.username)
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
        sender = Sender(id: senderId, displayName: senderName)
        self.content = content
    }
    
    var represantation: [String: Any] {
        let rep: [String: Any] = [
            "created": sentDate,
            "content": content,
            "senderName": sender.displayName,
            "senderId": sender.senderId
        ]
        return rep
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(messageId)
    }
    
    static func == (lhs: Message, rhs: Message) -> Bool {
        return lhs.messageId == rhs.messageId
    }

}
