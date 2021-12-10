//
//  LabelExtension.swift
//  Messager
//
//  Created by Сергей on 01.11.2021.
//

import UIKit

// custom init with text in label
extension UILabel {
    convenience init(textLabel: String) {
        self.init()
        self.text = textLabel
    }
    
}
