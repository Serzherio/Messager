//
//  UserCell.swift
//  Messager
//
//  Created by Сергей on 16.11.2021.
//

import UIKit

class UserCell: UICollectionViewCell, ConfiguringCell {
    
    let userImageView = UIImageView()
    let userName = UILabel(textLabel: "text")
    let containerView = UIView()
   
    
    static var reuseId: String = "UserCell"
  
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        setupConstraints()
    }
    
    func configure<U>(with value: U) where U : Hashable {
        guard let user: MessageUser = value as? MessageUser else { return }
        userImageView.image = UIImage(named: user.avatarStringURL)
        userName.text = user.username
        
        self.layer.shadowColor = UIColor.white.cgColor
        self.layer.shadowRadius = 5
        self.layer.shadowOffset = CGSize(width: 0, height: 4)
        self.layer.shadowOpacity = 0.5
    
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        self.containerView.layer.cornerRadius = 4
        self.containerView.clipsToBounds = true
    }
    
    private func setupConstraints() {
        self.userImageView.translatesAutoresizingMaskIntoConstraints = false
        self.userName.translatesAutoresizingMaskIntoConstraints = false
        self.containerView.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(containerView)
        self.containerView.addSubview(userImageView)
        self.containerView.addSubview(userName)
        
        NSLayoutConstraint.activate([
            self.containerView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
            self.containerView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0),
            self.containerView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
            self.containerView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0),
        ])
        
        NSLayoutConstraint.activate([
            self.userImageView.topAnchor.constraint(equalTo: self.containerView.topAnchor, constant: 0),
            self.userImageView.trailingAnchor.constraint(equalTo: self.containerView.trailingAnchor, constant: 0),
            self.userImageView.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor, constant: 0),
            self.userImageView.heightAnchor.constraint(equalTo: containerView.widthAnchor),
        ])
        NSLayoutConstraint.activate([
            self.userName.topAnchor.constraint(equalTo: self.userImageView.bottomAnchor, constant: 0),
            self.userName.trailingAnchor.constraint(equalTo: self.containerView.trailingAnchor, constant: -8),
            self.userName.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor, constant: 8),
            self.userName.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
        ])
        
    }
    
    

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
