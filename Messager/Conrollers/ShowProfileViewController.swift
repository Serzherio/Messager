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
        self.containerView.backgroundColor = .white
        self.containerView.layer.cornerRadius = 50
        self.containerView.layer.shadowRadius = 15
        self.containerView.layer.shadowOffset = CGSize(width: 0, height: -5)
        self.containerView.layer.shadowOpacity = 0.5
        self.containerView.layer.shadowColor = UIColor.gray.cgColor
        self.containerView.layer.masksToBounds = false
        self.textField.layer.borderWidth = 1
        self.textField.layer.borderColor = UIColor.systemGray.cgColor
        self.textField.layer.shadowRadius = 5
        self.textField.layer.shadowOffset = CGSize(width: 5, height: 5)
        self.textField.layer.shadowOpacity = 0.5
        self.textField.layer.shadowColor = UIColor.gray.cgColor
        self.textField.layer.masksToBounds = false
        
        
        setupConstraints()
        
        if let button = textField.rightView as? UIButton  {
            button.addTarget(self, action: #selector(sendMessage), for: .touchUpInside)
        }

//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
//        self.textField.delegate = self
    }
//
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
//        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
//    }
//
//    @objc func keyboardWillShow(notification: NSNotification) {
//        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
//            if self.view.frame.origin.y == 0 {
//                self.view.frame.origin.y -= keyboardSize.height
//            }
//        }
//    }
//    @objc func keyboardWillHide(notification: NSNotification) {
//        if self.view.frame.origin.y != 0 {
//            self.view.frame.origin.y = 0
//        }
//    }
    
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
            self.containerView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 50),
            self.containerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.containerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.containerView.heightAnchor.constraint(equalToConstant: 250)
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

// MARK: - UITextFieldDelegate
//extension ShowProfileViewController: UITextFieldDelegate {
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//           self.view.endEditing(true)
//           return false
//       }
//}


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
