//
//  MainTabBarController.swift
//  Messager
//  Created by Сергей on 07.11.2021.
//

import UIKit


// main Tab bar controller with two screens: ListViewController, PeopleViewController
class MainTabBarController: UITabBarController {
    
// variables
    let listViewController = ListViewController()
    let peopleViewController = PeopleViewController()
    
// view did load
    override func viewDidLoad() {
        super.viewDidLoad()

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
