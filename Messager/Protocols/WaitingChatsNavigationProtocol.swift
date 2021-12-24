//
//  WaitingChatsNavigationProtocol.swift
//  Messager
//
//  Created by Сергей on 16.12.2021.
//

import Foundation

protocol WaitingChatsNavigation: class {
    func removeWaitingChat(chat: MessageChat)
    func changeToActive(chat: MessageChat)
}
