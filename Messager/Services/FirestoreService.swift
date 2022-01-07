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

// variables
    var currentUser: MessageUser!
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
        var messageUser = MessageUser(username: username!, email: email, description: description!, avatarStringURL: "", sex: sex!, id: id)
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
    
// Функция создания ожидающего чата
// Принимает параметры: сообщение, отправитель сообщения, блок выполнения
// Создает новый документ в коллекции "waitingChat"
// В новом документе помещается пользователь с сообщением
// В случае успеха ничего не возвращает
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
    
// Функция создания активного чата
// Принимает параметры: чат, сообщения, блок выполнения
// Создает активный чат, копируя сообщения из ожидающего чата
// В случае успеха ничего не возвращает
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
                    } // messageRef.addDocumen
                } // for message in messages
            } // self.activeChatsRef.document
        } // func
    
// Функция удаления ожидающего чата
// Принимает параметры: чат, блок выполнения
// Находит и удаляет документ по ссылке на ожидающие чаты
// Вызывает функцию удаления всех сообщений "deleteMessages"
// В случае успеха ничего не возвращает
    func deleteWaitingChat(chat: MessageChat, completion: @escaping(Result<Void, Error>) -> Void) {
        self.waitingChatsRef.document(chat.friendId).delete { error in
            if let error = error {
                completion(.failure(error))
            }
            self.deleteMessages(chat: chat, completion: completion)
        }
    }

// Функция удаления всех сообщений
// Принимает параметры: чат, блок выполнения
// Находит ссылку на сообщения ожидающего чата
// Находит все сообщения ожидающего чата с помощью функции "getWaitingChatMessages"
// Удаляет все сообщения по ссылке
// В случае успеха ничего не возвращает
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
            } // switch result
        } // getWaitingChatMessages
    } // func
      

// Функция получения всех сообщений ожидающего чата
// Принимает параметры: чат, блок выполнения
// По ссылке на коллекцию "messages" в коллекции "waitingChat"
// Находит и добавляет все сообщения во внутренний массив "messages"
// В случае успеха возвращает массив сообщений "messages"
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
        self.getWaitingChatMessages(chat: chat) { (result) in  // getWaitingChatMessages
            switch result {
                case .success(let messages):
                        self.deleteWaitingChat(chat: chat) { (result) in // deleteWaitingChat
                            switch result {
                                case .success():
                                    self.createActiveChat(chat: chat, messages: messages) { (result) in // createActiveChat
                                        switch result {
                                            case .success():
                                                completion(.success(Void())) // completion!
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
    
// Функция отправки сообщения пользователю
// Принимает параметры: чат, сообщение,блок выполнения
// Находит ссылки на коллекию "activeChat" и в ней на коллекцию "messages"
// Создает ссылку на новый чат с другом, если она не создана
// Добавляет документ с новым сообщением по ссылке друга
// Добавляет документ с новым сообщением по ссылке на свои сообщения
// В случае успеха ничего не возвращает
    func sentMessage(chat: MessageChat, message: Message, completion: @escaping(Result<Void, Error>) -> Void) {
        let friendRef = usersRef.document(chat.friendId).collection("activeChat").document(currentUser.id)
        let friendMesRef = friendRef.collection("messages")
        let myMesRef = usersRef.document(currentUser.id).collection("activeChat").document(chat.friendId).collection("messages")
        let chatForFriend = MessageChat(friendUsername: currentUser.username, friendUserImageString: currentUser.avatarStringURL, lastMessageContent: message.content, friendId: currentUser.id)
        friendRef.setData(chatForFriend.represantation) { error in
            if let error = error {
                completion(.failure(error))
            }
            friendMesRef.addDocument(data: message.represantation) { error in
                if let error = error {
                    completion(.failure(error))
                }
                myMesRef.addDocument(data: message.represantation) { error in
                    if let error = error {
                        completion(.failure(error))
                    }
                    completion(.success(Void()))
                } // myMesRef.addDocument
            } // friendMesRef.addDocument
        } // friendRef.setData
    } // func
    
} // close class
