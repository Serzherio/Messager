//
//  ListenerService.swift
//  Messager
//
//  Created by Сергей on 12.12.2021.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseAuth
import UIKit


class ListenerService {
    
    static let shared = ListenerService()
    private let db = Firestore.firestore()
    private var usersRef: CollectionReference {
        db.collection("users")
    }
    private var currentUserId: String {
        return Auth.auth().currentUser!.uid
    }
    
    func waitingChatsObserve(chats: [MessageChat], completion: @escaping (Result<[MessageChat], Error>) -> Void) -> ListenerRegistration? {
        var chats = chats
        let chatReference = db.collection(["users", currentUserId, "waitingChat"].joined(separator: "/"))
        let chatListener = chatReference.addSnapshotListener { (querrySnapshot, error) in
            guard let querrySnapshot = querrySnapshot else {
                completion(.failure(error!))
                return
            }
            querrySnapshot.documentChanges.forEach { diff in
                guard let chat = MessageChat(document: diff.document) else {
                    return
                }
                switch diff.type {
                case .added:
                    guard !chats.contains(chat) else {return}
                    chats.append(chat)
                case .modified:
                    guard let index = chats.firstIndex(of: chat) else {return}
                    chats[index] = chat
                case .removed:
                    guard let index = chats.firstIndex(of: chat) else {return}
                    chats.remove(at: index)
                }
            }
            completion(.success(chats))
        }
        return chatListener
    }
    
    func activeChatsObserve(chats: [MessageChat], completion: @escaping (Result<[MessageChat], Error>) -> Void) -> ListenerRegistration? {
        var chats = chats
        let chatReference = db.collection(["users", currentUserId, "activeChat"].joined(separator: "/"))
        let chatListener = chatReference.addSnapshotListener { (querrySnapshot, error) in
            guard let querrySnapshot = querrySnapshot else {
                completion(.failure(error!))
                return
            }
            querrySnapshot.documentChanges.forEach { diff in
                guard let chat = MessageChat(document: diff.document) else {
                    return
                }
                switch diff.type {
                case .added:
                    guard !chats.contains(chat) else {return}
                    chats.append(chat)
                case .modified:
                    guard let index = chats.firstIndex(of: chat) else {return}
                    chats[index] = chat
                case .removed:
                    guard let index = chats.firstIndex(of: chat) else {return}
                    chats.remove(at: index)
                }
            }
            completion(.success(chats))
        }
        return chatListener
    }
    
    
    
    func usersObserve(users: [MessageUser], completion: @escaping (Result<[MessageUser], Error>) -> Void) -> ListenerRegistration? {
        var users = users
        let userListener = usersRef.addSnapshotListener { querySnapshot, error in
            guard let querySnapshot = querySnapshot else {
                completion(.failure(error!))
                return
            }
            querySnapshot.documentChanges.forEach { differences in
                guard let messageUser = MessageUser(document: differences.document) else {return}
                switch differences.type {
                case .added:
                    guard !users.contains(messageUser) else {return}
                    guard messageUser.id != self.currentUserId else {return}
                    users.append(messageUser)
                case .modified:
                    guard let index = users.firstIndex(of: messageUser) else {return}
                    users[index] = messageUser
                case .removed:
                    guard let index = users.firstIndex(of: messageUser) else {return}
                    users.remove(at: index)
                }
            }
            completion(.success(users))
        }
        return userListener
    }
    
    
    
}
