//
//  MainTabBarController.swift
//  Messager
//  Created by Сергей on 07.11.2021.
//

import UIKit


// main Tab bar controller with two screens: ListViewController, PeopleViewController
class MainTabBarController: UITabBarController {
    
    
// variables
    private let currentUser: MessageUser
    
    
    init(currentUser: MessageUser = MessageUser(username: "", email: "", description: "", avatarStringURL: "", sex: "", id: "")) {
        self.currentUser = currentUser
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
// view did load
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let listViewController = ListViewController(currentUser: currentUser)
        let peopleViewController = PeopleViewController(currentUser: currentUser)

        tabBar.tintColor = .magenta
        let boldConfig = UIImage.SymbolConfiguration(weight: .medium)
        let peopleImage = UIImage(systemName: "bubble.left.and.bubble.right", withConfiguration: boldConfig)!
        let convImage = UIImage(systemName: "person.2", withConfiguration: boldConfig)!
        
        viewControllers = [generateNavigationController(rootViewController: peopleViewController, title: "People", image: peopleImage),
                           generateNavigationController(rootViewController: listViewController, title: "Conversations", image: convImage)]
    }

// generate Navigation Controller for each rootViewController with title and image
    private func generateNavigationController(rootViewController: UIViewController, title: String, image: UIImage) -> UIViewController {
        let navigationVC = UINavigationController(rootViewController: rootViewController)
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white
        navigationVC.navigationBar.standardAppearance = appearance;
        navigationVC.navigationBar.scrollEdgeAppearance = navigationVC.navigationBar.standardAppearance
        navigationVC.tabBarItem.title = title
        navigationVC.tabBarItem.image = image
        return navigationVC
    }
    
}
