//
//  ViewController.swift
//  Messager
//  Created by Сергей on 01.11.2021.

import UIKit

/*
Autorization View Controller
The first VC, witch present methods to login
There is a app logo, sign in button with email, login button
 */

class AuthViewController: UIViewController {
    
// variables and constants
    let logoImageView = UIImageView(image: UIImage(named: "milan.png")!, contentMode: .scaleAspectFit)
    let emailLabel = UILabel(textLabel: "Registration with:")
    let onBoardLabel = UILabel(textLabel: "Have an account?")
    let emailButton = UIButton(title: "Email", titleColor: .black, backgroundColor: .white, font: .avenir26(), isShadow: true, cornerRadius: 10)
    let loginButton = UIButton(title: "Login", titleColor: .white, backgroundColor: .black, font: .avenir26(), isShadow: false, cornerRadius: 10)
    let signUpVC = SighUpViewController()
    let loginVC = LoginViewController()

// view did load
    override func viewDidLoad() {
        super.viewDidLoad()
        customDesign()
        self.setupConstrains()
        self.emailButton.addTarget(self, action: #selector(emailButtonTapped), for: .touchUpInside)
        self.loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
// delegates for AuthNavigationProtocol
        self.signUpVC.delegate = self
        self.loginVC.delegate = self
    }
    
// target button push function
// present SighUpViewController
    @objc func emailButtonTapped() {
        present(signUpVC, animated: true, completion: nil)
    }
    
// target button push function
// present LoginViewController
    @objc func loginButtonTapped() {
        present(loginVC, animated: true, completion: nil)
    }
    
// настройка дизайна интерфейса
    private func customDesign() {
        self.view.backgroundColor = .white
        self.emailLabel.font = UIFont.systemFont(ofSize: 20)
        self.onBoardLabel.font = UIFont.systemFont(ofSize: 20)
    }

// setup constraints for user interface
    private func setupConstrains() {
        self.logoImageView.translatesAutoresizingMaskIntoConstraints = false
        let emailView = LabelPlusButtonView(label: emailLabel, button: emailButton)
        let loginView = LabelPlusButtonView(label: onBoardLabel, button: loginButton)
        let stackView = UIStackView(arrangedSubviews: [emailView, loginView], axis: .vertical, spacing: 50)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.logoImageView)
        self.view.addSubview(stackView)
        
        
        
        let logoImageViewTopAnchor1 = logoImageView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 100)
        logoImageViewTopAnchor1.priority = UILayoutPriority(998)
        let logoImageViewTopAnchor2 = self.logoImageView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 50)
        logoImageViewTopAnchor2.priority = UILayoutPriority(997)
        
        NSLayoutConstraint.activate([
            stackView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -80),
            stackView.topAnchor.constraint(greaterThanOrEqualTo: self.logoImageView.bottomAnchor, constant: 50),
            stackView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 40),
            stackView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -40),
            stackView.heightAnchor.constraint(equalToConstant: 320),
            logoImageViewTopAnchor1,
            logoImageViewTopAnchor2,
            self.logoImageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.logoImageView.heightAnchor.constraint(equalToConstant: 150),
            self.logoImageView.widthAnchor.constraint(equalToConstant: 150)
        ])
    }
}

// MARK: - AuthNavigationDelegate
extension AuthViewController: AuthNavigationDelegate {
// show LoginViewController after login button push
    func toLoginVC() {
        present(loginVC, animated: true, completion: nil)
    }
// show SignUpViewController after email button push
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

