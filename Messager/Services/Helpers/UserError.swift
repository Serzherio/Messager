//
//  AuthError.swift
//  Messager
//
//  Created by Сергей on 21.11.2021.
//

import Foundation

// enum UserError with errors in user Model
enum UserError {
    case notFilled
    case photoNotExist
    case cannotGetUserInfo
    case cannotUnwrapToModel
}

// desctiption for every error
extension UserError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .notFilled:
            return NSLocalizedString("Не заполнены поля", comment: "")
        case .photoNotExist:
            return NSLocalizedString("Фото не существует", comment: "")
        case .cannotGetUserInfo:
            return NSLocalizedString("Невозможно загрузить информацию", comment: "")
        case .cannotUnwrapToModel:
            return NSLocalizedString("Невозможно конвертировать модель", comment: "")
        }
    }
}
