//
//  WaitingChatCell.swift
//  Messager
//
//  Created by Сергей on 09.11.2021.
//

import UIKit

class WaitingChatCell: UICollectionViewCell, ConfiguringCell {
    
    static var reuseId: String = "WaitingChatCell"
    private var friendImageView = UIImageView()
    
    func configure<U>(with value: U) where U : Hashable {
        guard let chat: MessageChat = value as? MessageChat else { return }
        friendImageView.image = UIImage(named: chat.userImageString)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .yellow
        setupConstraints()
    }
    
    private func setupConstraints() {
        friendImageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(friendImageView)
        NSLayoutConstraint.activate([
            self.friendImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
            self.friendImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0),
            self.friendImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
            self.friendImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0),
        ])
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
