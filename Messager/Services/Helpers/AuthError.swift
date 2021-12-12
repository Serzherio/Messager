//
//  AuthError.swift
//  Messager
//
//  Created by Сергей on 21.11.2021.
//

import Foundation

// enum AuthError with error at authorization
enum AuthError {
    case notFilled
    case invalidEmail
    case passNotMatched
    case unknownError
    case serverError
}

// desctiption for every error
extension AuthError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .notFilled:
            return NSLocalizedString("Поля не заполнены", comment: "Заполните все поля")
        case .invalidEmail:
            return NSLocalizedString("Ошибка логина/пароля", comment: "Неверные данные для входа")
        case .passNotMatched:
            return NSLocalizedString("Ошибка логина/пароля", comment: "Неверные данные для входа")
        case .unknownError:
            return NSLocalizedString("Неизвестная ошибка", comment: "Повторите вход")
        case .serverError:
            return NSLocalizedString("Ошибка сервера", comment: "В данный момент ведутся работы на сервере")
        }
        
    }
}
