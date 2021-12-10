//  ProfileViewController.swift
//  Messager
//  Created by Сергей on 05.11.2021.


import UIKit
import FirebaseAuth
// ProfileViewController
class ProfileViewController: UIViewController {

// variables and constants
    let fullImageView = AddPhotoView()
    let fullNameLabel = UILabel(textLabel: "Full name")
    let aboutMeLabel = UILabel(textLabel: "About me")
    let sexLabel = UILabel(textLabel: "Sex")
    let fullNameTextField = OneLineTextField(font: .avenir20())
    let aboutMeTextField = OneLineTextField(font: .avenir20())
    let sexSegmentedControl = UISegmentedControl(first: "male", second: "female")
    let goToChartsButton = UIButton(title: "Go charts", titleColor: .black, backgroundColor: .white, font: .avenir20(), isShadow: true, cornerRadius: 4)
    let welcomeLabel: UILabel = {
        let label = UILabel(textLabel: "Set up profile")
        label.font = .avenir26()
        return label
    }()
    
    private let currentUser: User
    
    init(currentUser: User) {
        self.currentUser = currentUser
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
// view did load
    override func viewDidLoad() {
        super.viewDidLoad()
        setupConstraints()
        self.view.backgroundColor = .white
        
        self.fullImageView.plusButton.addTarget(self, action: #selector(plusButtonTapped), for: .touchUpInside)
        self.goToChartsButton.addTarget(self, action: #selector(goToChartsButtonTapped), for: .touchUpInside)
    }
    
    @objc private func plusButtonTapped() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        present(imagePickerController, animated: true, completion: nil)
    }
    
    @objc private func goToChartsButtonTapped() {
        FirestoreService.shared.saveProfileWith(id: currentUser.uid,
                                                email: currentUser.email!,
                                                username: fullNameTextField.text,
                                                avatarImage: fullImageView.circleImageView.image,
                                                description: aboutMeTextField.text,
                                                sex: sexSegmentedControl.titleForSegment(at: sexSegmentedControl.selectedSegmentIndex)) { (result) in
            switch result {
            case .success(let messageUser):
                self.showAlert(title: "Успешно", messege: "Приятного общения!") {
                    let mainTabBar = MainTabBarController(currentUser: messageUser)
                    mainTabBar.modalPresentationStyle = .fullScreen
                    self.present(mainTabBar, animated: true, completion: nil)
                }
            case .failure(let error):
                self.showAlert(title: "Ошибка", messege: error.localizedDescription)
            }
        }
    }
}


extension ProfileViewController {
    
// setup constraints with custom stack view
// fullNameStackView
// aboutMeStackView
// sexStackView
    private func setupConstraints() {
        
        let fullNameStackView = UIStackView(arrangedSubviews: [self.fullNameLabel, self.fullNameTextField], axis: .vertical, spacing: 0)
        let aboutMeStackView = UIStackView(arrangedSubviews: [self.aboutMeLabel, self.aboutMeTextField], axis: .vertical, spacing: 0)
        let sexStackView = UIStackView(arrangedSubviews: [self.sexLabel, self.sexSegmentedControl], axis: .vertical, spacing: 12)
        self.goToChartsButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        let stackView = UIStackView(arrangedSubviews: [fullNameStackView,aboutMeStackView,sexStackView,goToChartsButton], axis: .vertical, spacing: 40)
        self.fullImageView.translatesAutoresizingMaskIntoConstraints = false
        self.welcomeLabel.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.welcomeLabel)
        self.view.addSubview(fullImageView)
        self.view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            welcomeLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 100),
            welcomeLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            fullImageView.topAnchor.constraint(equalTo: self.welcomeLabel.bottomAnchor, constant: 40),
            fullImageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: self.fullImageView.bottomAnchor, constant: 50),
            stackView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 40),
            stackView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -40),
        ])
    }
}


// MARK: - UIImagePickerControllerDelegate
extension ProfileViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            return
        }
        fullImageView.circleImageView.image = image
    }
}

// MARK: - SwiftUI provider for canvas
import SwiftUI

struct ProfileVCProvider: PreviewProvider {
    static var previews: some View {
        ContainerView().previewDevice("iPhone 13 Pro Max").edgesIgnoringSafeArea(.all)
    }
    
    struct ContainerView: UIViewControllerRepresentable {
        let viewController = ProfileViewController(currentUser: Auth.auth().currentUser!)
        func makeUIViewController(context: UIViewControllerRepresentableContext<ProfileVCProvider.ContainerView>) -> ProfileViewController {
            return viewController
        }
        func updateUIViewController(_ uiViewController: ProfileVCProvider.ContainerView.UIViewControllerType, context: UIViewControllerRepresentableContext<ProfileVCProvider.ContainerView>) {
        }
    }
}
