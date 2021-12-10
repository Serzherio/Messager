//
//  FirestoreService.swift
//  Messager
//
//  Created by Сергей on 21.11.2021.
//

import Firebase
import FirebaseFirestore
import UIKit

class FirestoreService {
    static let shared = FirestoreService()
    
    let db = Firestore.firestore()
    
    private var usersRef: CollectionReference {
        return db.collection("users")
    }
    
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

    
    func saveProfileWith(id: String, email:String, username: String?, avatarImage: UIImage?, description: String?, sex: String?, completion: @escaping(Result<MessageUser, Error>) -> Void) {
        guard Validators.isFilled(username: username, description: description, sex: sex) else {
            completion(.failure(UserError.notFilled))
            return
        }
        guard avatarImage != UIImage.init(named: "logoPhoto.pdf") else {
            completion(.failure(UserError.photoNotExist))
            return
        }
        
        var messageUser = MessageUser(username: username!, email: email, description: description!, avatarStringURL: "lol", sex: sex!, id: id)
        
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
