//
//  CustomTextField.swift
//  Messager
//
//  Created by Сергей on 02.11.2021.
//

import UIKit

class OneLineTextField: UITextField {
    
    convenience init (font: UIFont? = .avenir20()) {
        self.init()
        self.font = font
        self.borderStyle = .none
        self.translatesAutoresizingMaskIntoConstraints = false
        var bottomLineView = UIView()
        bottomLineView = UIView(frame: CGRect.init(x: 0, y: 0, width: 0, height: 0))
        bottomLineView.backgroundColor = .systemGray
        bottomLineView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(bottomLineView)
        
        NSLayoutConstraint.activate([
            bottomLineView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            bottomLineView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            bottomLineView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            bottomLineView.heightAnchor.constraint(equalToConstant: 1)
        ])
    }
}
