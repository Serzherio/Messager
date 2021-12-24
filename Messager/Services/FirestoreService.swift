//
//  FirestoreService.swift
//  Messager
//
//  Created by Сергей on 21.11.2021.
//

import Firebase
import FirebaseFirestore
import UIKit

/*
 class FirestoreService
 responsible for saving data of exist user
 responsible for getting data of exist user
 */
class FirestoreService {

// singleton
    static let shared = FirestoreService()
// database
    let db = Firestore.firestore()
    
// reference for folder in firebase database
    private var usersRef: CollectionReference {
        return db.collection("users")
    }
  
    private var waitingChatsRef: CollectionReference {
        return db.collection(["users", currentUser.id, "waitingChat"].joined(separator: "/"))
    }
    private var activeChatsRef: CollectionReference {
        return db.collection(["users", currentUser.id, "activeChat"].joined(separator: "/"))
    }
    
    var currentUser: MessageUser!
    

// get user data func takes user and completion block with Result onboard
// return all user data if exists
    func getUserData(user: User, completion: @escaping(Result<MessageUser, Error>) -> Void) {
        let docRef = usersRef.document(user.uid)
        docRef.getDocument { document, error in
            if let document = document, document.exists {
                guard let messageUser = MessageUser(document: document) else {
                    completion(.failure(UserError.cannotUnwrapToModel))
                    return
                }
                self.currentUser = messageUser
                completion(.success(messageUser))
            } else {
                completion(.failure(UserError.cannotGetUserInfo))
            }
        }
    }

// save user profile func takes id, email, username, user avatar
    func saveProfileWith(id: String, email:String, username: String?, avatarImage: UIImage?, description: String?, sex: String?, completion: @escaping(Result<MessageUser, Error>) -> Void) {
        guard Validators.isFilled(username: username, description: description, sex: sex) else {
            completion(.failure(UserError.notFilled))
            return
        }
        guard avatarImage != UIImage.init(named: "logoPhoto.pdf") else {
            completion(.failure(UserError.photoNotExist))
            return
        }
        var messageUser = MessageUser(username: username!, email: email, description: description!, avatarStringURL: " ", sex: sex!, id: id)

// upload data on server
// upload user avatar
        StorageServices.shared.upload(photo: avatarImage!) { result in
            switch result {
            case .success(let url):
                messageUser.avatarStringURL = url.absoluteString
                self.usersRef.document(messageUser.id).setData(messageUser.representation) { error in
                    if let error = error {
                        completion(.failure(error))
                    } else {
                        completion(.success(messageUser))
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    
    func createWaitingChat(message: String, reciever: MessageUser,  completion: @escaping(Result<Void, Error>) -> Void) {
        let reference = db.collection(["users", reciever.id, "waitingChat"].joined(separator: "/"))
        let messageReference = reference.document(self.currentUser.id).collection("messages")
        let message = Message(user: currentUser, content: message)
        let chat = MessageChat(friendUsername: currentUser.username,
                               friendUserImageString: currentUser.avatarStringURL,
                               lastMessageContent: message.content,
                               friendId: currentUser.id)
    
        reference.document(currentUser.id).setData(chat.represantation) { error in
            if let error = error {
                completion(.failure(error))
                return
            }
            messageReference.addDocument(data: message.represantation) { error in
                if let error = error {
                    completion(.failure(error))
                }
                completion(.success(Void()))
            }
        }
    }
    
    // создать активный чат, копируя сообщения из ожидающего чата
        func createActiveChat(chat: MessageChat, messages: [Message], completion: @escaping(Result<Void, Error>) -> Void) {
            let messageRef = activeChatsRef.document(chat.friendId).collection("messages")
            self.activeChatsRef.document(chat.friendId).setData(chat.represantation) { error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                for message in messages {
                    messageRef.addDocument(data: message.represantation) { error in
                        if let error = error {
                            completion(.failure(error))
                            return
                        }
                        completion(.success(Void()))
                    }
                }
            }
        }
    
    func deleteWaitingChat(chat: MessageChat, completion: @escaping(Result<Void, Error>) -> Void) {
        self.waitingChatsRef.document(chat.friendId).delete { error in
            if let error = error {
                completion(.failure(error))
            }
            self.deleteMessages(chat: chat, completion: completion)
        }
    }
    
    private func deleteMessages(chat: MessageChat, completion: @escaping(Result<Void, Error>) -> Void) {
        let ref = waitingChatsRef.document(chat.friendId).collection("messages")
        getWaitingChatMessages(chat: chat) { (result) in
            switch result {
            case .success(let messages):
                for message in messages {
                    guard let documentId = message.id else {return}
                    let messageRef = ref.document(documentId)
                    messageRef.delete { error in
                        if let error = error {
                            completion(.failure(error))
                            return
                        }
                        completion(.success(Void()))
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
      
 
    
    private func getWaitingChatMessages(chat: MessageChat, completion: @escaping(Result<[Message], Error>) -> Void) {
        var messages = [Message]()
        let ref = waitingChatsRef.document(chat.friendId).collection("messages")
        ref.getDocuments { quarySnapshot, error in
            if let error = error {
                completion(.failure(error))
            }
            for document in quarySnapshot!.documents {
                guard let message = Message(document: document) else {return}
                messages.append(message)
            }
            completion(.success(messages))
        }
    }
    
// перевести чат из ожидающего статуса в активный
// получаем все сообщения из ожидающего чата
// удаляем все сообщения из ожидающего чата
// создаем новый активный чат с удаленными сообщениями
    func changeToActive(chat: MessageChat, completion: @escaping(Result<Void, Error>) -> Void) {
  
        self.getWaitingChatMessages(chat: chat) { (result) in
            switch result {
            case .success(let messages):
                self.deleteWaitingChat(chat: chat) { (result) in
                    switch result {
                    case .success():
                        self.createActiveChat(chat: chat, messages: messages) { (result) in
                            switch result {
                            case .success():
                                completion(.success(Void()))
                            case .failure(let error):
                                completion(.failure(error))
                            }
                        }
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
        
    }
    

    
    
    
}
