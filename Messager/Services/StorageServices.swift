//
//  StorageServices.swift
//  Messager
//
//  Created by Сергей on 10.12.2021.
//

import Foundation
import FirebaseAuth
import FirebaseStorage



class StorageServices {
    
    static let shared = StorageServices()
    
    let storageRef = Storage.storage().reference()
    private var avatarsRef: StorageReference {
        return storageRef.child("Avatars")
    }
    
    private var currentUserID: String {
        return Auth.auth().currentUser!.uid
    }
    
    func upload(photo: UIImage, completion: @escaping(Result<URL, Error>) -> Void) {
        
        guard let scaleddImage = photo.scaledToSafeUploadSize, let imageData = scaleddImage.jpegData(compressionQuality: 0.4) else { return }
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpeg"
        avatarsRef.child(currentUserID).putData(imageData, metadata: metaData) { metadata, error in
            guard let _ = metadata else {
                completion(.failure(error!))
                return
            }
            self.avatarsRef.child(self.currentUserID).downloadURL { url, error in
                guard let downloadURL = url else {
                    completion(.failure(error!))
                    return
                }
                completion(.success(downloadURL))
                
            }
            
        }
        
        
    }
}
