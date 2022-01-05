//
//  ActiveChatCell.swift
//  Messager
//
//  Created by Сергей on 08.11.2021.
//

import UIKit
import SDWebImage



class ActiveChatCell: UICollectionViewCell, ConfiguringCell {
    
    static var reuseId: String = "ActiveChatCell"
    
    var friendImage = UIImageView()
    let friendNameLabel = UILabel(textLabel: "User")
    let lastMessageLabel = UILabel(textLabel: "How a u?")
    let gradientView = GradientView(from: .topTrailing, to: .bottomLeading, startColor: .magenta, endColor: .green)
    
    
    func configure<U>(with value: U) where U : Hashable {
        guard let chat: MessageChat = value as? MessageChat else { return }
        friendNameLabel.text = chat.friendUsername
        lastMessageLabel.text = chat.lastMessageContent
        friendImage.sd_setImage(with: URL(string: chat.friendUserImageString), completed: nil)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        setupConstraints()
        self.layer.cornerRadius = 4
        self.clipsToBounds = true
        
    }
    
   
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


// MARK: - setupConstraints
extension ActiveChatCell {
    private func setupConstraints() {
        friendNameLabel.translatesAutoresizingMaskIntoConstraints = false
        friendImage.translatesAutoresizingMaskIntoConstraints = false
        friendImage.backgroundColor = .white
        gradientView.backgroundColor = .white
        lastMessageLabel.translatesAutoresizingMaskIntoConstraints = false
        gradientView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(friendImage)
        addSubview(gradientView)
        addSubview(friendNameLabel)
        addSubview(lastMessageLabel)
        
        NSLayoutConstraint.activate([
            self.friendImage.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.friendImage.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            self.friendImage.widthAnchor.constraint(equalToConstant: 78),
            self.friendImage.heightAnchor.constraint(equalToConstant: 78),
        ])
        NSLayoutConstraint.activate([
            self.gradientView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.gradientView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            self.gradientView.widthAnchor.constraint(equalToConstant: 8),
            self.gradientView.heightAnchor.constraint(equalToConstant: 78),
        ])
        NSLayoutConstraint.activate([
            self.friendNameLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 16),
            self.friendNameLabel.leadingAnchor.constraint(equalTo: self.friendImage.trailingAnchor, constant: 16),
            self.friendNameLabel.trailingAnchor.constraint(equalTo: self.gradientView.leadingAnchor, constant: 16),
        ])
        NSLayoutConstraint.activate([
            self.lastMessageLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -16),
            self.lastMessageLabel.leadingAnchor.constraint(equalTo: self.friendImage.trailingAnchor, constant: 16),
            self.lastMessageLabel.trailingAnchor.constraint(equalTo: self.gradientView.leadingAnchor, constant: 16),
        ])
    }
}
