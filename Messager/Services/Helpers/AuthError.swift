//
//  AuthError.swift
//  Messager
//
//  Created by Сергей on 21.11.2021.
//

import Foundation

enum AuthError {
    case notFilled
    case invalidEmail
    case passNotMatched
    case unknownError
    case serverError
}

extension AuthError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .notFilled:
            return NSLocalizedString("Заполните все поля", comment: "")
        case .invalidEmail:
            return NSLocalizedString("Почта неверна", comment: "")
        case .passNotMatched:
            return NSLocalizedString("Пароли не совпадают", comment: "Пароли не совпадают")
        case .unknownError:
            return NSLocalizedString("Ошибка", comment: "")
        case .serverError:
            return NSLocalizedString("Ошибка сервера", comment: "")
        }
        
    }
}
