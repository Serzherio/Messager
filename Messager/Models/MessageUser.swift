//
//  MessageUser.swift
//  Messager
//  Created by Сергей on 15.11.2021.

import Foundation
import FirebaseFirestore

/*
 model "MessageUser"
 data struct to complete list of users
*/

struct MessageUser: Hashable, Decodable {
    var username: String
    var email: String
    var description: String
    var avatarStringURL: String
    var sex: String
    var id : String
    
    init(username: String, email: String, description: String, avatarStringURL: String, sex: String, id: String) {
        self.username = username
        self.email = email
        self.description = description
        self.avatarStringURL = avatarStringURL
        self.sex = sex
        self.id = id
    }
    
    init?(document: DocumentSnapshot) {
        guard let data = document.data() else {return nil}
        guard let username = data["username"] as? String,
              let email = data["email"] as? String,
              let avatarStringURL = data["avatarStringURL"] as? String,
              let description = data["description"] as? String,
              let sex = data["sex"] as? String,
              let id = data["id"] as? String else {return nil}
        self.username = username
        self.email = email
        self.avatarStringURL = avatarStringURL
        self.description = description
        self.sex = sex
        self.id = id
        
    }
    
    var representation: [String: Any] {
        var rep = ["username": username]
        rep["username"] = username
        rep["email"] = email
        rep["description"] = description
        rep["avatarStringURL"] = avatarStringURL
        rep["sex"] = sex
        rep["id"] = id
        return rep
    }
    
    func hash(into haser: inout Hasher){
        haser.combine(id)
    }
    
    static func  == (lhs: MessageUser, rhs: MessageUser) -> Bool {
        return lhs.id == rhs.id
    }
    func containts(filter: String?) -> Bool {
        guard let filter = filter else { return true }
        if filter.isEmpty { return true }
        let lowercasedFilter = filter.lowercased()
        return username.lowercased().contains(lowercasedFilter)
        
    }
}
