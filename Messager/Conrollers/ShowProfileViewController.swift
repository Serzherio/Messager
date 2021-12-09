//
//  ProfileViewController.swift
//  Messager
//
//  Created by Сергей on 17.11.2021.
//

import UIKit

class ShowProfileViewController: UIViewController {
    
    let imageView = UIImageView(image: .checkmark, contentMode: .scaleAspectFit)
    let containerView = UIView()
    let nameLabel = UILabel(textLabel: "Peter")
    let aboutMeLabel = UILabel(textLabel: "It is me")
    let textField = ShowProfileTextField()
    
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
        
    }
    
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
        let viewController = ShowProfileViewController()
        func makeUIViewController(context: UIViewControllerRepresentableContext<ShowProfileVCProvider.ContainerView>) -> ShowProfileViewController {
            return viewController
        }
        func updateUIViewController(_ uiViewController: ShowProfileVCProvider.ContainerView.UIViewControllerType, context: UIViewControllerRepresentableContext<ShowProfileVCProvider.ContainerView>) {
        }
    }
}
