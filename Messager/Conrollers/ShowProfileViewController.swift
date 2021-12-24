//
//  ProfileViewController.swift
//  Messager
//
//  Created by Сергей on 17.11.2021.
//

import UIKit
import SDWebImage

class ShowProfileViewController: UIViewController {
    
    let imageView = UIImageView(image: .checkmark, contentMode: .scaleAspectFit)
    let containerView = UIView()
    let nameLabel = UILabel(textLabel: "Peter")
    let aboutMeLabel = UILabel(textLabel: "It is me")
    let textField = ShowProfileTextField()
    
    private let user: MessageUser
    
    init(user: MessageUser) {
        self.user = user
        self.nameLabel.text = user.username
        self.aboutMeLabel.text = user.description
        self.imageView.sd_setImage(with: URL(string:user.avatarStringURL), completed: nil)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        self.aboutMeLabel.numberOfLines = 0
        self.containerView.backgroundColor = .gray
        self.containerView.layer.cornerRadius = 30
        
      
        setupConstraints()
        
        if let button = textField.rightView as? UIButton  {
            button.addTarget(self, action: #selector(sendMessage), for: .touchUpInside)
        }
    }
    
    @objc private func sendMessage() {
        guard let message = textField.text, message != "" else {return}
        
        self.dismiss(animated: true) {
            FirestoreService.shared.createWaitingChat(message: message, reciever: self.user) { (result) in
                switch result {
                case .success():
                    self.topMostController()?.showAlert(title: "Отлично", message: "Пользователь получил ваше сообщение")
                case .failure(let error):
                    self.topMostController()?.showAlert(title: "Ошибка", message: error.localizedDescription)
                } // result
            } // createWaitingChats
        } // dismiss
    } // sendMessage

}

extension ShowProfileViewController {
    
    private func setupConstraints() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        containerView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        aboutMeLabel.translatesAutoresizingMaskIntoConstraints = false
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(imageView)
        self.view.addSubview(containerView)
        self.containerView.addSubview(nameLabel)
        self.containerView.addSubview(aboutMeLabel)
        self.containerView.addSubview(textField)
        
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
            self.textField.topAnchor.constraint(equalTo: self.aboutMeLabel.bottomAnchor, constant: 10),
            self.textField.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor, constant: 24),
            self.textField.trailingAnchor.constraint(equalTo: self.containerView.trailingAnchor, constant: -24),
            self.textField.heightAnchor.constraint(equalToConstant: 48)
        ])
        
    }
    
}

// MARK: - SwiftUI provider for canvas
import SwiftUI

struct ShowProfileVCProvider: PreviewProvider {
    static var previews: some View {
        ContainerView().previewDevice("iPhone 13 Pro Max").edgesIgnoringSafeArea(.all)
    }
    
    struct ContainerView: UIViewControllerRepresentable {
        let viewController = ShowProfileViewController(user: MessageUser(username: "", email: "", description: "", avatarStringURL: "", sex: "", id: ""))
        func makeUIViewController(context: UIViewControllerRepresentableContext<ShowProfileVCProvider.ContainerView>) -> ShowProfileViewController {
            return viewController
        }
        func updateUIViewController(_ uiViewController: ShowProfileVCProvider.ContainerView.UIViewControllerType, context: UIViewControllerRepresentableContext<ShowProfileVCProvider.ContainerView>) {
        }
    }
}
