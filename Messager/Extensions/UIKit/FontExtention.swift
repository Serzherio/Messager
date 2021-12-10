//
//  FontExtention.swift
//  Messager
//
//  Created by Сергей on 01.11.2021.
//

import UIKit

// extension for UIFont class to add new font for project
// font - avenir, size - 20
// font - avenir, size - 26
extension UIFont {
    static func avenir20() -> UIFont? {
        return self.init(name: "avenir", size: 20)
    }
    static func avenir26() -> UIFont? {
        return self.init(name: "avenir", size: 26)
    }
}

