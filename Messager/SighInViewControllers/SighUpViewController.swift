//
//  SighUpViewController.swift
//  Messager
//
//  Created by Сергей on 01.11.2021.
//

import UIKit

// SighUpViewController
class SighUpViewController: UIViewController {

// variables and constants
    let welcomeLabel = UILabel(textLabel: "Good to see you!")
    let emailLabel = UILabel(textLabel: "Email")
    let passwordLabel = UILabel(textLabel: "Password")
    let confirmPasswordLabel = UILabel(textLabel: "Confirm password")
    let onBoardLabel = UILabel(textLabel: "Allready on board?")
    let emailTextField = OneLineTextField(font: .avenir20())
    let passwordTextField = OneLineTextField(font: .avenir20())
    let confirmPasswordTextField = OneLineTextField(font: .avenir20())
    let sighUpButton = UIButton(title: "Sigh up", titleColor: .white, backgroundColor: .black, font: .avenir20(), isShadow: true, cornerRadius: 4)
    let loginButton = UIButton()
    
    weak var delegate: AuthNavigationDelegate?

// view did load
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.welcomeLabel.font = .avenir26()
        self.loginButton.setTitle("Login", for: .normal)
        self.loginButton.setTitleColor(.red, for: .normal)
        self.setupConstrains()
        
        sighUpButton.addTarget(self, action: #selector(sighUpButtonTapped), for: .touchUpInside)
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
    }

    @objc private func sighUpButtonTapped() {
        AuthService.shared.register(email: emailTextField.text, password: passwordTextField.text, confirmPassword: confirmPasswordTextField.text) { (result) in
            switch result {
            case .success(let user):
                self.showAlert(title: "Поздравляю", messege: "Вы зарегистрированы!") {
                    self.present(ProfileViewController(currentUser: user), animated: true, completion: nil)
                }
            case .failure(let error):
                self.showAlert(title: "Zelupa", messege: "Error")
            }
        }
    }
    
    @objc private func loginButtonTapped() {
        self.dismiss(animated: true) {
            self.delegate?.toLoginVC()
        }
    }
    
// setup constraints
// custom StackView containts UILabel and Text Field with own init in extension
// emailStackView
// passwordStackView
// confirmPasswordStackView
    private func setupConstrains() {
        let emailStackView = UIStackView(arrangedSubviews: [emailLabel, emailTextField], axis: .vertical, spacing: 5)
        let passwordStackView = UIStackView(arrangedSubviews: [passwordLabel, passwordTextField], axis: .vertical, spacing: 5)
        let confirmPasswordStackView = UIStackView(arrangedSubviews: [confirmPasswordLabel, confirmPasswordTextField], axis: .vertical, spacing: 5)
        self.sighUpButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        let stackView = UIStackView(arrangedSubviews: [emailStackView, passwordStackView, confirmPasswordStackView, sighUpButton], axis: .vertical, spacing: 100)
        self.loginButton.contentHorizontalAlignment = .leading
        let bottomStackView = UIStackView(arrangedSubviews: [onBoardLabel, loginButton], axis: .horizontal, spacing: 10)
        bottomStackView.alignment = .firstBaseline
        stackView.translatesAutoresizingMaskIntoConstraints = false
        bottomStackView.translatesAutoresizingMaskIntoConstraints = false
        self.welcomeLabel.translatesAutoresizingMaskIntoConstraints = false
        self.sighUpButton.translatesAutoresizingMaskIntoConstraints = false

        self.view.addSubview(stackView)
        self.view.addSubview(bottomStackView)
        self.view.addSubview(welcomeLabel)
        
        NSLayoutConstraint.activate([
            self.welcomeLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 70),
            self.welcomeLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: self.welcomeLabel.bottomAnchor, constant: 50),
            stackView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 40),
            stackView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -40),
        ])
        
        NSLayoutConstraint.activate([
            bottomStackView.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 50),
            bottomStackView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 40),
            bottomStackView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -40),
        ])
    }
}

// MARK: - SwiftUI provider for canvas
import SwiftUI
struct SignUpVCProvider: PreviewProvider {
    static var previews: some View {
        ContainerView().previewDevice("iPhone 13 Pro Max").edgesIgnoringSafeArea(.all)
    }
    struct ContainerView: UIViewControllerRepresentable {
        let viewController = SighUpViewController()
        func makeUIViewController(context: Context) -> some UIViewController {
            return viewController
        }
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        }
    }
}

extension UIViewController {
    func showAlert(title: String, messege: String, completion: @escaping () -> Void = {} ) {
        let alert = UIAlertController(title: title, message: messege, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default) { _ in
            completion()
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}
