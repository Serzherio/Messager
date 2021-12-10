//
//  AuthNavigationDelegate.swift
//  Messager
//
//  Created by Сергей on 21.11.2021.
//

import Foundation

// AuthNavigation protocol
// transition to loginVC or SignVC
protocol AuthNavigationDelegate: class {
    func toLoginVC()
    func toSingVC()
}
