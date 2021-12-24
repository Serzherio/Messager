//
//  ViewControllerExtension.swift
//  Messager
//
//  Created by Сергей on 17.11.2021.
//

import UIKit

extension UIViewController {
    
    func configure<T: ConfiguringCell, U: Hashable>(collectionView: UICollectionView, cellType: T.Type, with value: U, for indexPath: IndexPath) -> T {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: T.reuseId, for: indexPath) as? T else { fatalError("Unable to dequeue cell") }
        cell.configure(with: value)
        return cell
    }
}

extension UIViewController {
    func topMostController() -> UIViewController? {
        guard let window = UIApplication.shared.keyWindow, let rootViewController = window.rootViewController else {
            return nil
        }
        var topController = rootViewController
        while let newTopController = topController.presentedViewController {
            topController = newTopController
        }
        return topController
    }
}
