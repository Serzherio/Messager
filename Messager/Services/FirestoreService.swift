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
}
