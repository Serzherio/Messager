//
//  CharRequestViewController.swift
//  Messager
//
//  Created by Сергей on 18.11.2021.
//

import UIKit

class CharRequestViewController: UIViewController {
    
    let imageView = UIImageView(image: .checkmark, contentMode: .scaleAspectFit)
    let containerView = UIView()
    let aboutMeLabel = UILabel(textLabel: "Start Chat")
    let nameLabel = UILabel(textLabel: "Peter")
    let acceptButton = UIButton(title: "ACCEPT", titleColor: .white, backgroundColor: .black, font: .avenir26(), isShadow: false, cornerRadius: 10)
    let denyButton = UIButton(title: "DENY", titleColor: .red, backgroundColor: .white, font: .avenir26(), isShadow: false, cornerRadius: 10)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .gray
        setupConstraints()
        customiseElements()
    }
    
    private func customiseElements() {
        self.denyButton.layer.borderWidth = 1.2
        self.denyButton.layer.borderColor = UIColor.red.cgColor
        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = 30
    }
}

extension CharRequestViewController {
    
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

// MARK: - SwiftUI provider for canvas
import SwiftUI

struct CharRequestVCProvider: PreviewProvider {
    static var previews: some View {
        ContainerView().previewDevice("iPhone 13 Pro Max").edgesIgnoringSafeArea(.all)
    }
    
    struct ContainerView: UIViewControllerRepresentable {
        let viewController = CharRequestViewController()
        func makeUIViewController(context: UIViewControllerRepresentableContext<CharRequestVCProvider.ContainerView>) -> CharRequestViewController {
            return viewController
        }
        func updateUIViewController(_ uiViewController: CharRequestVCProvider.ContainerView.UIViewControllerType, context: UIViewControllerRepresentableContext<CharRequestVCProvider.ContainerView>) {
        }
    }
}
