//
//  ModelChat.swift
//  Messager
//
//  Created by Сергей on 15.11.2021.
//

import Foundation
import FirebaseFirestore

// model "messageChat"
// model for layout in List VC
// data struct for active chat
    struct MessageChat: Hashable, Decodable {
        var friendUsername: String
        var friendUserImageString: String
        var lastMessageContent: String
        var friendId: String
        
        var represantation: [String: Any] {
            var rep = ["friendUsername": friendUsername]
            rep["friendUserImageString"] = friendUserImageString
            rep["lastMessage"] = lastMessageContent
            rep["friendId"] = friendId
            return rep
        }
        
        init(friendUsername: String, friendUserImageString: String, lastMessageContent: String, friendId: String) {
            self.friendUsername = friendUsername
            self.friendUserImageString = friendUserImageString
            self.lastMessageContent = lastMessageContent
            self.friendId = friendId
        }
        
        init?(document: QueryDocumentSnapshot) {
            let data = document.data()
            guard let friendUsername = data["friendUsername"] as? String,
                  let friendUserImageString = data["friendUserImageString"] as? String,
                  let lastMessageContent = data["lastMessage"] as? String,
                  let friendId = data["friendId"] as? String else {
                      return nil
                  }
            self.friendUsername = friendUsername
            self.friendUserImageString = friendUserImageString
            self.lastMessageContent = lastMessageContent
            self.friendId = friendId
        }
        
        func hash(into haser: inout Hasher){
            haser.combine(friendId)
        }
        
        static func  == (lhs: MessageChat, rhs: MessageChat) -> Bool {
            return lhs.friendId == rhs.friendId
        }
    }
