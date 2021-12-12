//
//  LoginViewController.swift
//  Messager
//  Created by Сергей on 02.11.2021.

import UIKit

/*
 LoginViewController
VC, witch present fields for login into chat
There is a email textField, password textField,
                            login button, and transition button to signVC
 */
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
    
// custom override Text Field with new font
    let emailTextField = OneLineTextField(font: .avenir20())
    let passwordTextField = OneLineTextField(font: .avenir20())
    
// view did load
    override func viewDidLoad() {
        super.viewDidLoad()
        self.welcomeLabel.font = .avenir26()
        self.googleButton.customButtonWithGooleLogo()
        self.view.backgroundColor = .white
        setUpConstraints()
        
// add targets oo buttons
        self.loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        self.signUpButton.addTarget(self, action: #selector(signUpButtonTapped), for: .touchUpInside)
        
    }

// loginButtonTapped
// login exist user
// show alert with result of login, return success or failure
    @objc private func loginButtonTapped() {
        AuthService.shared.login(email: emailTextField.text, password: passwordTextField.text) { result in
            switch result {
// return exist user in success case
            case .success(let loginUser):
                self.showAlert(title: "Поздравляю", message: "Вы авторизованы!") {
                // try to get user data according to user model
                    FirestoreService.shared.getUserData(user: loginUser) { result in
                        switch result {
                    // show MainTabBarController if user data is complete
                        case .success(let messageUser):
                            let mainTabBar = MainTabBarController(currentUser: messageUser)
                            mainTabBar.modalPresentationStyle = .fullScreen
                            self.present(mainTabBar, animated: true, completion: nil)
                    // show ProfileViewController if user data isn't complete
                        case .failure(_):
                            self.present(ProfileViewController(currentUser: loginUser), animated: true, completion: nil)
                        }
                    } // close getUserData
                } // close alert
// return error in failure case
            case .failure(let error):
                self.showAlert(title: "Ошибка авторизации", message: error.localizedDescription)
            }
        } // close AuthService.shared.login
    }
    
// signUpButtonTapped
// close this VC and show signVC
// delegate opening signVC VC to AuthVC
    @objc private func signUpButtonTapped() {
        dismiss(animated: true) {
            self.delegate?.toSingVC()
        }
    }
}

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
