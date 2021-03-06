//
//  StorageServices.swift
//  Messager
//
//  Created by Сергей on 10.12.2021.
//

import Foundation
import FirebaseAuth
import FirebaseStorage

/*
 class StorageServices
 responsible for uploading data to server
 */
class StorageServices {

// singleton
    static let shared = StorageServices()

// reference in database
    let storageRef = Storage.storage().reference()
    private var avatarsRef: StorageReference {
        return storageRef.child("Avatars")
    }
    private var chatsRef: StorageReference {
        return storageRef.child("chats")
    }
    
// return user id
    private var currentUserID: String {
        return Auth.auth().currentUser!.uid
    }
    
// функция загрузки фотографии аватара
// принимает фото, блок выполнения
// сжимает фото с помощью функции "scaledToSafeUploadSize"
// по ссылке на хранилище аватаров по "currentUserID" сохраняет фото
// в случае успеха возвращает ссылку на аватар пользователя
    func upload(photo: UIImage, completion: @escaping(Result<URL, Error>) -> Void) {
        guard let scaledImage = photo.scaledToSafeUploadSize, let imageData = scaledImage.jpegData(compressionQuality: 0.4) else { return }
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
        } //  avatarsRef.child
    } // func
    
// функция отправки фотографии в чат с пользователем
// принимает фото, чат, блок выполнения
// сжимает фото с помощью функции "scaledToSafeUploadSize"
// по ссылке на чат сохраняет ссылку на фотографию
// // в случае успеха возвращает ссылку на фотографию
    func uploadPhotoMessage(photo: UIImage, to chat: MessageChat, completion: @escaping(Result<URL, Error>) -> Void) {
        guard let scaledImage = photo.scaledToSafeUploadSize, let imageData = scaledImage.jpegData(compressionQuality: 1) else { return }
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpeg"
        let imageName = [UUID().uuidString, String(Date().timeIntervalSince1970)].joined()
        let chatName = [chat.friendUsername, Auth.auth().currentUser!.uid].joined()
        self.chatsRef.child(chatName).child(imageName).putData(imageData, metadata: metaData) { metadata, error in
            guard let _ = metadata else {
                completion(.failure(error!))
                return
            }
            self.chatsRef.child(chatName).child(imageName).downloadURL { url, error in
                guard let downloadURL = url else {
                    completion(.failure(error!))
                    return
                }
                completion(.success(downloadURL))
            } // self.chatsRef.child
        }
    } // func
    
// функция скачивания изображения
// принимает ссылку для скачивания и блок выполнения
// по ссылке на хранилище с параметром размера скачивает изображение
// в случае успеха возвращает изображение
    func downloadImage(url: URL, completion: @escaping(Result<UIImage?, Error>) -> Void) {
        let ref = Storage.storage().reference(forURL: url.absoluteString)
        let megaByte = Int64(10*1024*1024)
        ref.getData(maxSize: megaByte) { data, error in
            guard let imageData = data else {
                completion(.failure(error!))
                return
            }
            completion(.success(UIImage(data: imageData)))
        } // ref.getData
    } // func
    
} // class
