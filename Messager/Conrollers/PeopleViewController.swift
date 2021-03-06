//
//  PeopleViewController.swift
//  Messager
//
//  Created by Сергей on 07.11.2021.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class PeopleViewController: UIViewController {
    
    var users: [MessageUser] = []
// user listener works when smthg appears on server (new, modify, delete)
    private var userListener : ListenerRegistration?
    var collectionView : UICollectionView!
    var dataSourse: UICollectionViewDiffableDataSource<Section, MessageUser>?
    private let currentUser: MessageUser
    
    enum Section: Int, CaseIterable {
        case users
        func description(userCount: Int) -> String {
            switch self {
            case .users:
                return("\(userCount) people nearby")
            }
        }
    }

    init(currentUser: MessageUser) {
        self.currentUser = currentUser
        super.init(nibName: nil, bundle: nil)
        title = currentUser.username
    }

// delete user listener
    deinit {
        userListener?.remove()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        setupSearchBar()
        setupCollectionView()
        createDataSource()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Log Out", style: .plain, target: self, action: #selector(signOut))
        
        userListener = ListenerService.shared.usersObserve(users: users, completion: { result in
            switch result {
            case .success(var users):
                self.users = users
                self.reloadData(with: nil)
            case .failure(let error):
                self.showAlert(title: "Ошибка", message: error.localizedDescription)
            }
        })
    }
    
    @objc private func signOut() {
        let ac = UIAlertController(title: nil, message: "Out", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        ac.addAction(UIAlertAction(title: "Sign Out", style: .destructive, handler: { _ in
            do {
                try Auth.auth().signOut()
                UIApplication.shared.keyWindow?.rootViewController = AuthViewController()
            } catch {
                print("Error")
            }
        }))
        present(ac, animated: true, completion: nil)
    }
    
    // Setting collection View
    // Pass CompositionalLayout into collectionViewLayout
    private func setupCollectionView() {
        self.collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: createCompositionalLayout())
        self.collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.collectionView.backgroundColor = .white
        self.view.addSubview(self.collectionView)
        self.collectionView.register(SectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeader.reuseId)
        self.collectionView.register(UserCell.self, forCellWithReuseIdentifier: UserCell.reuseId)
        self.collectionView.delegate = self
        
        
    }
    
    
    private func setupSearchBar() {
        
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.shadowImage = UIImage()
        let searchController = UISearchController(searchResultsController: nil)
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
        
    }
}

//MARK: - Setup Compositional layout
extension PeopleViewController {
    
    // Using Compositional layout
    // Setting item, group, section
    private func createCompositionalLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, layoutEnviroment) -> NSCollectionLayoutSection? in
            guard let section = Section(rawValue: sectionIndex) else {fatalError("No section")}
            switch section {
            case .users:
                return self.createUserSection()
            
            }
        }
        let configiration = UICollectionViewCompositionalLayoutConfiguration()
        configiration.interSectionSpacing = 20
        layout.configuration = configiration
        return layout
    
    }
    private func createUserSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(0.6))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
        group.interItemSpacing = .fixed(16)
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 16, bottom: 0, trailing: 16)
        section.interGroupSpacing = 16
        let sectionHeaderSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(1))
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: sectionHeaderSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        section.boundarySupplementaryItems = [sectionHeader]
        return section
    }
}

// MARK: - Data Source and reload Data
extension PeopleViewController {
 
    private func createDataSource() {
        self.dataSourse = UICollectionViewDiffableDataSource<Section, MessageUser>(collectionView: self.collectionView, cellProvider: { (collectionView, indexPath, user) -> UICollectionViewCell? in
            guard let section = Section(rawValue: indexPath.section) else {fatalError("No section")}
            switch section {
            case .users:
                return self.configure(collectionView: collectionView, cellType: UserCell.self, with: user, for: indexPath)
            }
        })
        self.dataSourse?.supplementaryViewProvider = {
            collectionView, kind, indexPath in
            guard let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionHeader.reuseId, for: indexPath) as? SectionHeader else {return nil}
            guard let items = self.dataSourse?.snapshot().itemIdentifiers(inSection: .users) else {return nil}
            guard let section = Section(rawValue: indexPath.section) else { return nil }
            sectionHeader.configure(text: section.description(userCount: items.count),
                                    font: .avenir20(),
                                    textColor: .systemBlue)
            return sectionHeader

        }
    }
    private func reloadData(with text: String?) {
        let filterUser = users.filter { (user) in
            user.containts(filter: text)
        }
        var snapshot = NSDiffableDataSourceSnapshot<Section, MessageUser>()
        snapshot.appendSections([.users])
        snapshot.appendItems(filterUser, toSection: .users)
        self.dataSourse?.apply(snapshot, animatingDifferences: true)
    }
}

// MARK: - Search Bar Delegate
extension PeopleViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        reloadData(with: searchText)
    }
    
}

// MARK:  - UICollectionViewDelegate
extension PeopleViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let user = self.dataSourse?.itemIdentifier(for: indexPath) else {return}
        let profileVC = ShowProfileViewController(user: user)
        present(profileVC, animated: true, completion: nil)
    }
}

// MARK: - SwiftUI provider for canvas
import SwiftUI

struct PeopleVCProvider: PreviewProvider {
    static var previews: some View {
        ContainerView().previewDevice("iPhone 13 Pro Max").edgesIgnoringSafeArea(.all)
    }
    
    struct ContainerView: UIViewControllerRepresentable {
        let tabBarController = MainTabBarController()
        func makeUIViewController(context: UIViewControllerRepresentableContext<PeopleVCProvider.ContainerView>) -> MainTabBarController {
            return tabBarController
        }
        func updateUIViewController(_ uiViewController: PeopleVCProvider.ContainerView.UIViewControllerType, context: UIViewControllerRepresentableContext<PeopleVCProvider.ContainerView>) {
        }
    }
}
