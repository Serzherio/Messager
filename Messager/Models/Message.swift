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


struct ImageItem: MediaItem {
    var url: URL?
    var image: UIImage?
    var placeholderImage: UIImage
    var size: CGSize
    
    
}

struct Message: Hashable, MessageType {
    

    let content: String
    var sender: SenderType
    var sentDate: Date
    let id: String?
    
    var messageId: String {
        return id ?? UUID().uuidString
    }
    
    var kind: MessageKind {
        if let image = image {
            let mediaItem = ImageItem(url: nil, image: nil, placeholderImage: image, size: image.size)
            return .photo(mediaItem)
        } else {
            return .text(content)
        }
    }
    
    var image: UIImage? = nil
    var downloadURL: URL? = nil
    
    init(user: MessageUser, image: UIImage) {
        sender = Sender(id: user.id, displayName: user.username)
        self.image = image
        content = ""
        sentDate = Date()
        id = nil
        
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
//        guard let content = data["content"] as? String else {return nil}
        
        self.id = document.documentID
        self.sentDate = sentDate.dateValue()
        sender = Sender(id: senderId, displayName: senderName)
        
        if let content = data["content"] as? String {
            self.content = content
            downloadURL = nil
        } else if let urlString = data["url"] as? String, let url = URL(string: urlString) {
            downloadURL = url
            self.content = ""
        } else {
            return nil
        }
    }
    
    var represantation: [String: Any] {
        var rep: [String: Any] = [
            "created": sentDate,
            "senderName": sender.displayName,
            "senderId": sender.senderId
        ]
        if let url = downloadURL {
            rep["url"] = url.absoluteString
        } else {
            rep["content"] = content
        }
        return rep
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(messageId)
    }
    
    static func == (lhs: Message, rhs: Message) -> Bool {
        return lhs.messageId == rhs.messageId
    }

}

extension Message: Comparable {
    static func < (lhs: Message, rhs: Message) -> Bool {
        lhs.sentDate < rhs.sentDate
    }
    
    
}
