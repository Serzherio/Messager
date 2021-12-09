//
//  ShowProfileTextField.swift
//  Messager
//
//  Created by Сергей on 18.11.2021.
//

import UIKit

class ShowProfileTextField: UITextField {
    
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor  = .white
        self.placeholder = "Write here"
        self.font = .systemFont(ofSize: 14)
        self.borderStyle = .none
        self.clearButtonMode = .whileEditing
        self.layer.cornerRadius = 18
        self.layer.masksToBounds = true
        
        let image = UIImage(systemName: "smiley")
        let imageView = UIImageView(image: image)
        self.leftView = imageView
        self.leftView?.frame = CGRect(x: 0, y: 0, width: 19, height: 19)
        self.leftViewMode = .always
        
        let button = UIButton(type: .system)
        let imageButton = UIImage(named:"plusButton.pdf")
        button.setImage(imageButton, for: .normal)
        self.rightView = button
        self.rightView?.frame = CGRect(x: 0, y: 0, width: 19, height: 19)
        self.rightViewMode = .always
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 36, dy: 0)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 36, dy: 0)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 36, dy: 0)
    }
    
    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        var rect = super.leftViewRect(forBounds: bounds)
        rect.origin.x += 12
        return rect
    }
    override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        var rect = super.rightViewRect(forBounds: bounds)
        rect.origin.x += -12
        return rect
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
