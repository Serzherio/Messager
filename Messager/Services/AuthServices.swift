//
//  AuthServices.swift
//  Messager
//
//  Created by Сергей on 20.11.2021.
//

import UIKit
import Firebase
import FirebaseAuth

/*
 class AuthService
 responsible for authorization exist users and registration new users
 */
class AuthService {
    
// singleton
    static let shared = AuthService()
    private let auth = Auth.auth()

// login func takes email, password, and completion block with Result onboard
    func login(email: String?, password: String?, completion: @escaping (Result <User,Error>) -> Void) {
        
        guard let email = email, let password = password else {
            completion(.failure(AuthError.notFilled))
            return
        }
// signIn exist users
// in success case completion block takes exist user
// in failure completion block takes error
        auth.signIn(withEmail: email, password: password) { (result, error) in
            guard let result = result else {
                completion(.failure(error!))
                return
            }
            completion(.success(result.user))
        }
    }
    
    
// register func takes email, password, and completion block with Result onboard
// check email and password tf are filled
// check matching password
// check correct email
    func register(email: String?, password: String?, confirmPassword: String?, completion: @escaping (Result <User , Error>) -> Void) {

        guard Validators.isFilled(email: email, password: password, confirmPassword: confirmPassword) else {
            completion(.failure(AuthError.notFilled))
            return
        }
        guard password!.lowercased() == confirmPassword!.lowercased() else {
            completion(.failure(AuthError.passNotMatched))
            return
        }
        guard Validators.isSimpleEmail(email!) else {
            completion(.failure(AuthError.invalidEmail))
            return
        }
        
// create new user
// in success case completion block takes exist user
// in failure completion block takes error
        self.auth.createUser(withEmail: email!, password: password!) { (result, error) in
            guard let result = result else {
                completion(.failure(error!))
                return
            }
            completion(.success(result.user))
        }
    }
}
