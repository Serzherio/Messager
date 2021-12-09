//
//  ViewController.swift
//  Messager
//  Created by Сергей on 01.11.2021.

import UIKit

// Autorization View Controller
// The first VC, witch present you methods to Log in
class AuthViewController: UIViewController {
    
// variables and constants
    let logoImageView = UIImageView(image: UIImage(named: "titleLogo.pdf")!, contentMode: .scaleAspectFit)
    let googleLabel = UILabel(textLabel: "Get started")
    let emailLabel = UILabel(textLabel: "Sign with")
    let onBoardLabel = UILabel(textLabel: "On board")
    let emailButton = UIButton(title: "Email", titleColor: .black, backgroundColor: .white, font: .avenir20(), isShadow: true, cornerRadius: 4)
    let loginButton = UIButton(title: "Login", titleColor: .white, backgroundColor: .black, font: .avenir20(), isShadow: false, cornerRadius: 4)
    let googleButton = UIButton(title: "Google", titleColor: .red, backgroundColor: .white, font: .avenir20(), isShadow: true, cornerRadius: 4)
    
    let signUpVC = SighUpViewController()
    let loginVC = LoginViewController()

// view did load
    override func viewDidLoad() {
        super.viewDidLoad()
        self.googleButton.customButtonWithGooleLogo()
        self.view.backgroundColor = .white
        self.setupConstrains()
        
        self.emailButton.addTarget(self, action: #selector(emailButtonTapped), for: .touchUpInside)
        self.loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        
        self.signUpVC.delegate = self
        self.loginVC.delegate = self
    }
    
    @objc func emailButtonTapped() {
        present(signUpVC, animated: true, completion: nil)
    }
    
    @objc func loginButtonTapped() {
        present(loginVC, animated: true, completion: nil)
    }

// setup constraints for user interface
    private func setupConstrains() {
        self.logoImageView.translatesAutoresizingMaskIntoConstraints = false
        let googleView = LabelPlusButtonView(label: googleLabel, button: googleButton)
        let emailView = LabelPlusButtonView(label: emailLabel, button: emailButton)
        let loginView = LabelPlusButtonView(label: onBoardLabel, button: loginButton)
        let stackView = UIStackView(arrangedSubviews: [googleView, emailView, loginView], axis: .vertical, spacing: 50)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.logoImageView)
        self.view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: self.logoImageView.bottomAnchor, constant: 100),
            stackView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 40),
            stackView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -40),
            self.logoImageView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 150),
            self.logoImageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        ])
    }
}

extension AuthViewController: AuthNavigationDelegate {
    
    func toLoginVC() {
        present(loginVC, animated: true, completion: nil)
    }
    
    func toSingVC() {
        present(signUpVC, animated: true, completion: nil)
    }
    
    
}

// MARK: - SwiftUI provider for canvas
import SwiftUI
struct AuthVCProvider: PreviewProvider {
    static var previews: some View {
        ContainerView().previewDevice("iPhone 13 Pro Max").edgesIgnoringSafeArea(.all)
    }
    struct ContainerView: UIViewControllerRepresentable {
        let viewController = AuthViewController ()
        func makeUIViewController(context: Context) -> some UIViewController {
            return viewController
        }
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        }
    }
}

