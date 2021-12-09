//
//  LoginViewController.swift
//  Messager
//  Created by Сергей on 02.11.2021.

import UIKit

// LoginViewController
class LoginViewController: UIViewController {

// variables and constants
    let welcomeLabel = UILabel(textLabel: "Welcome back")
    let loginWithLabel = UILabel(textLabel: "Login with")
    let orLabel = UILabel(textLabel: "or")
    let emailLabel = UILabel(textLabel: "Email")
    let passwordLabel = UILabel(textLabel: "Password")
    let needAnAccountLabel = UILabel(textLabel: "Need an account?")
    let googleButton = UIButton(title: "Google", titleColor: .white, backgroundColor: .black, font: .avenir20(), isShadow: true, cornerRadius: 4)
    let loginButton = UIButton(title: "Login", titleColor: .black, backgroundColor: .white, font: .avenir20(), isShadow: true, cornerRadius: 4)
    let signUpButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("sign in", for: .normal)
        button.setTitleColor(UIColor.red, for: .normal)
        button.titleLabel?.font = .avenir20()
        return button
    }()
    
    weak var delegate: AuthNavigationDelegate?
    
// custom override Text Field
    let emailTextField = OneLineTextField(font: .avenir20())
    let passwordTextField = OneLineTextField(font: .avenir20())
    
// view did load
    override func viewDidLoad() {
        super.viewDidLoad()
        self.welcomeLabel.font = .avenir26()
        self.googleButton.customButtonWithGooleLogo()
        self.view.backgroundColor = .white
        setUpConstraints()
        self.loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        self.signUpButton.addTarget(self, action: #selector(signUpButtonTapped), for: .touchUpInside)
        
    }
    
    @objc private func loginButtonTapped() {
        AuthService.shared.login(email: emailTextField.text, password: passwordTextField.text) { result in
            switch result {
            case .success(let user):
                self.showAlert(title: "Поздравляю", messege: "Вы авторизованы!") {
                    FirestoreService.shared.getUserData(user: user) { result in
                        switch result {
                        case .success(let muser):
                            self.present(MainTabBarController(), animated: true, completion: nil)
                        case .failure(let error):
                            self.present(ProfileViewController(currentUser: user), animated: true, completion: nil)
                        }
                    }
                    
                }
            case .failure(let error):
                self.showAlert(title: "error", messege: error.localizedDescription)
            }
        }
    }
    
    @objc private func signUpButtonTapped() {
        dismiss(animated: true) {
            self.delegate?.toSingVC()
        }
    }
    
}

// Hello


//MARK: - Constraints
extension LoginViewController {
    
    private func setUpConstraints() {
        let loginView = LabelPlusButtonView(label: self.loginWithLabel, button: self.googleButton)
        let emailStackView = UIStackView(arrangedSubviews: [self.emailLabel, self.emailTextField], axis: .vertical, spacing: 0)
        let passwordStackView = UIStackView(arrangedSubviews: [self.passwordLabel, self.passwordTextField], axis: .vertical, spacing: 0)
        self.loginButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        let stackView = UIStackView(arrangedSubviews: [loginView, orLabel, emailStackView, passwordStackView, loginButton], axis: .vertical, spacing: 40)
        self.signUpButton.contentHorizontalAlignment = .leading
        let bottomStackView = UIStackView(arrangedSubviews: [self.needAnAccountLabel, self.signUpButton], axis: .horizontal, spacing: 0)
        bottomStackView.alignment = .firstBaseline
        self.welcomeLabel.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        bottomStackView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(self.welcomeLabel)
        self.view.addSubview(stackView)
        self.view.addSubview(bottomStackView)
        
        NSLayoutConstraint.activate([
            welcomeLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 100),
            welcomeLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
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

struct LoginVCProvider: PreviewProvider {
    static var previews: some View {
        ContainerView().previewDevice("iPhone 13 Pro Max").edgesIgnoringSafeArea(.all)
    }
    
    struct ContainerView: UIViewControllerRepresentable {
        let viewController = LoginViewController()
        func makeUIViewController(context: UIViewControllerRepresentableContext<LoginVCProvider.ContainerView>) -> LoginViewController {
            return viewController
        }
        func updateUIViewController(_ uiViewController: LoginVCProvider.ContainerView.UIViewControllerType, context: UIViewControllerRepresentableContext<LoginVCProvider.ContainerView>) {
        }
    }
}
