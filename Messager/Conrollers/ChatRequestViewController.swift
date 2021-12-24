//
//  CharRequestViewController.swift
//  Messager
//
//  Created by Сергей on 18.11.2021.
//

import UIKit
import SDWebImage


class ChatRequestViewController: UIViewController {
    
    let imageView = UIImageView(image: .checkmark, contentMode: .scaleAspectFit)
    let containerView = UIView()
    let aboutMeLabel = UILabel(textLabel: "Начать беседу")
    let nameLabel = UILabel(textLabel: "Имя")
    let acceptButton = UIButton(title: "Принять", titleColor: .white, backgroundColor: .black, font: .avenir26(), isShadow: false, cornerRadius: 10)
    let denyButton = UIButton(title: "Отклонить", titleColor: .red, backgroundColor: .white, font: .avenir26(), isShadow: false, cornerRadius: 10)
    private var chat: MessageChat
    weak var delegate: WaitingChatsNavigation?
    
    init(chat: MessageChat) {
        self.chat = chat
        self.nameLabel.text = chat.friendUsername
        self.imageView.sd_setImage(with: URL(string: chat.friendUserImageString), completed: nil)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .gray
        setupConstraints()
        customiseElements()
        
        self.denyButton.addTarget(self, action: #selector(denyButtonPressed), for: .touchUpInside)
        self.acceptButton.addTarget(self, action: #selector(acceptButtonPressed), for: .touchUpInside)
        
    }
    
    @objc private func denyButtonPressed() {
        self.dismiss(animated: true) {
            self.delegate?.removeWaitingChat(chat: self.chat)
        }
    }
    @objc private func acceptButtonPressed() {
        self.dismiss(animated: true) {
            self.delegate?.changeToActive(chat: self.chat)
        }
    }
    
    private func customiseElements() {
        self.denyButton.layer.borderWidth = 1.2
        self.denyButton.layer.borderColor = UIColor.red.cgColor
        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = 30
    }
}

extension ChatRequestViewController {
    
    private func setupConstraints() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        containerView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        aboutMeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(imageView)
        self.view.addSubview(containerView)
        self.containerView.addSubview(nameLabel)
        self.containerView.addSubview(aboutMeLabel)
        
        let buttonsStackView = UIStackView(arrangedSubviews: [acceptButton, denyButton], axis: .horizontal, spacing: 10)
        buttonsStackView.translatesAutoresizingMaskIntoConstraints = false
        buttonsStackView.distribution = .fillEqually
        self.containerView.addSubview(buttonsStackView)
        
        NSLayoutConstraint.activate([
            self.containerView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            self.containerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.containerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.containerView.heightAnchor.constraint(equalToConstant: 200)
        ])
        NSLayoutConstraint.activate([
            self.imageView.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.imageView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.imageView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.imageView.bottomAnchor.constraint(equalTo: self.containerView.topAnchor, constant: 30)
        ])
        NSLayoutConstraint.activate([
            self.nameLabel.topAnchor.constraint(equalTo: self.containerView.topAnchor, constant: 30),
            self.nameLabel.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor, constant: 24),
            self.nameLabel.trailingAnchor.constraint(equalTo: self.containerView.trailingAnchor, constant: -24),
        ])
        NSLayoutConstraint.activate([
            self.aboutMeLabel.topAnchor.constraint(equalTo: self.nameLabel.bottomAnchor, constant: 10),
            self.aboutMeLabel.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor, constant: 24),
            self.aboutMeLabel.trailingAnchor.constraint(equalTo: self.containerView.trailingAnchor, constant: -24),
        ])
        NSLayoutConstraint.activate([
            buttonsStackView.topAnchor.constraint(equalTo: self.aboutMeLabel.bottomAnchor, constant: 10),
            buttonsStackView.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor, constant: 24),
            buttonsStackView.trailingAnchor.constraint(equalTo: self.containerView.trailingAnchor, constant: -24),
            buttonsStackView.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
}
