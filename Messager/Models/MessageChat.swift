//
//  ModelChat.swift
//  Messager
//
//  Created by Сергей on 15.11.2021.
//

import Foundation

// model "messageChat"
// model for layout in List VC
// data struct for active chat
    struct MessageChat: Hashable, Decodable {
        var username: String
        var userImageString: String
        var lastMessage: String
        var id : Int
        
        func hash(into haser: inout Hasher){
            haser.combine(id)
        }
        
        static func  == (lhs: MessageChat, rhs: MessageChat) -> Bool {
            return lhs.id == rhs.id
        }
    }
