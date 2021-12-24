//
//  ListViewController.swift
//  Messager
//
//  Created by Сергей on 07.11.2021.
//

import UIKit
import FirebaseFirestore

class ListViewController: UIViewController {
    
  
    // enum with section's types
    enum Section: Int, CaseIterable {
        case waitingChats, activeChats
        func description() -> String {
            switch self {
            case .waitingChats:
                return "Waiting Chats"
            case .activeChats:
                return "Active Chats"
            }
        }
    }
    
    // variables

    // fake data from json files
    var activeChats =  [MessageChat]()
    var waitingChats = [MessageChat]()
    // intanse of colllection view
    var collectionView : UICollectionView!
    // diffable data sourse
    var dataSourse: UICollectionViewDiffableDataSource<Section, MessageChat>?
    private let currentUser: MessageUser
    private var waitingChatListener: ListenerRegistration?
    private var activeChatListener: ListenerRegistration?
    
    init(currentUser: MessageUser) {
        self.currentUser = currentUser
        super.init(nibName: nil, bundle: nil)
        title = currentUser.username
    }
    
    deinit {
        self.waitingChatListener?.remove()
        self.activeChatListener?.remove()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
// view did load
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .lightGray
        setupSearchBar()
        setupCollectionView()
        createDataSource()
        reloadData()
        
        waitingChatListener = ListenerService.shared.waitingChatsObserve(chats: waitingChats, completion: { result in
            switch result {
            case .success(let chats):
                if self.waitingChats != [], self.waitingChats.count <= chats.count {
                    let charRequestVC = ChatRequestViewController(chat: chats.last!)
                    charRequestVC.delegate = self
                    self.present(charRequestVC, animated: true, completion: nil)
                    // TODO: 
                }
                self.waitingChats = chats
                self.reloadData()
            case .failure(let error):
                self.showAlert(title: "Ошибка", message: "Ожидающие чаты не доступны")
            }
        })
        
        activeChatListener = ListenerService.shared.activeChatsObserve(chats: activeChats, completion: { result in
            switch result {
            case .success(let chats):
                self.activeChats = chats
                self.reloadData()
            case .failure(let error):
                self.showAlert(title: "Ошибка", message: error.localizedDescription)
            }
        })
    }
    
    // Setting Search Bar
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
    
    
    // Setting collection View
    // Pass CompositionalLayout into collectionViewLayout
    // Setup CompositionalLayout
    // Register sections and cell into collection view
    private func setupCollectionView() {
        self.collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: createCompositionalLayout())
        self.collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.collectionView.backgroundColor = .systemGray
        self.view.addSubview(self.collectionView)
        self.collectionView.register(SectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeader.reuseId)
        self.collectionView.register(WaitingChatCell.self, forCellWithReuseIdentifier: WaitingChatCell.reuseId)
        self.collectionView.register(ActiveChatCell.self, forCellWithReuseIdentifier: ActiveChatCell.reuseId)
        
        self.collectionView.delegate = self
    }
    
}

// MARK: - Data Source and reload Data
extension ListViewController {
    
    // private func createDataSource
    // create and setup cell for different type of cells in collection view
    private func createDataSource() {
        self.dataSourse = UICollectionViewDiffableDataSource<Section, MessageChat>(collectionView: self.collectionView, cellProvider: { (collectionView, indexPath, chat) -> UICollectionViewCell? in
            guard let section = Section(rawValue: indexPath.section) else {fatalError("No section")}
            switch section {
            case .activeChats:
                return self.configure(collectionView: collectionView, cellType: ActiveChatCell.self, with: chat, for: indexPath)
            case .waitingChats:
                return self.configure(collectionView: collectionView, cellType: WaitingChatCell.self, with: chat, for: indexPath)
            }
        })
    // create Section headers for different type of cells in collection view
        self.dataSourse?.supplementaryViewProvider = {
            collectionView, kind, indexPath in
            guard let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionHeader.reuseId, for: indexPath) as? SectionHeader else {return nil}
            guard let section = Section(rawValue: indexPath.section) else { return nil }
            sectionHeader.configure(text: section.description(), font: .avenir26(), textColor: .magenta)
            return sectionHeader
                    
        }
    }
    // private func reloadData
    // reload data and append it to data sourse 
    private func reloadData() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, MessageChat>()
        snapshot.appendSections([.waitingChats, .activeChats])
        snapshot.appendItems(activeChats, toSection: .activeChats)
        snapshot.appendItems(waitingChats, toSection: .waitingChats)
        self.dataSourse?.apply(snapshot, animatingDifferences: true)
    }
}


//MARK: - Setup Compositional layout
extension ListViewController {
    
    // Using Compositional layout
    // Setting item, group, section
    private func createCompositionalLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, layoutEnviroment) -> NSCollectionLayoutSection? in
            guard let section = Section(rawValue: sectionIndex) else {fatalError("No section")}
            switch section {
            case .activeChats:
                return self.createActiveChats()
            case .waitingChats:
                return self.createWaitingChats()
            }
        }
        let configiration = UICollectionViewCompositionalLayoutConfiguration()
        configiration.interSectionSpacing = 20
        layout.configuration = configiration
        return layout
    
    }
    private func createWaitingChats() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(88), heightDimension: .absolute(88))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 16, bottom: 0, trailing: 16)
        section.interGroupSpacing = 16
        let sectionHeaderSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(1))
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: sectionHeaderSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        section.boundarySupplementaryItems = [sectionHeader]
        return section
    }
    
    private func createActiveChats() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(78))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 16, bottom: 0, trailing: 16)
        section.interGroupSpacing = 16
        let sectionHeaderSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(1))
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: sectionHeaderSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        section.boundarySupplementaryItems = [sectionHeader]
        return section
    }
}

// MARK: - UICollectionViewDelegate
extension ListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let chat = self.dataSourse?.itemIdentifier(for: indexPath) else {return}
        guard let section = Section(rawValue: indexPath.section) else {return}
        switch section {
        case .waitingChats:
            let chatRequestVC = ChatRequestViewController(chat: chat)
            chatRequestVC.delegate = self
            self.present(chatRequestVC, animated: true, completion: nil)
        case .activeChats:
            let chatVC = ChatsViewController(user: currentUser, chat: chat)
            navigationController?.pushViewController(chatVC, animated: true)
        }
    }
}


// MARK: - WaitingChatsNavigation
extension ListViewController: WaitingChatsNavigation {
    func removeWaitingChat(chat: MessageChat) {
        FirestoreService.shared.deleteWaitingChat(chat: chat) { result in
            switch result {
            case .success():
                self.showAlert(title: "Успешно", message: "Чат с \(chat.friendUsername) был удален")
            case .failure(let error):
                self.showAlert(title: "Ошибка", message: error.localizedDescription)
            }
        }
    }
    
    func changeToActive(chat: MessageChat) {
        FirestoreService.shared.changeToActive(chat: chat) { result in
            switch result {
            case .success():
                self.showAlert(title: "Успешно", message: "Приятного общения!")
            case .failure(let error):
                self.showAlert(title: "Ошибка", message: "Невозможно начать чат")
            }
        }
    }
    
    
}
            
            
            // MARK: - Search Bar Delegate
            // Recieve and parse text from Search bar
            extension ListViewController: UISearchBarDelegate {
                func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
                    print(searchText)
                }
            }
            
            // MARK: - SwiftUI provider for canvas
            import SwiftUI
            
            struct ListVCProvider: PreviewProvider {
                static var previews: some View {
                    ContainerView().previewDevice("iPhone 13 Pro Max").edgesIgnoringSafeArea(.all)
                }
                
                struct ContainerView: UIViewControllerRepresentable {
                    let tabBarController = MainTabBarController()
                    func makeUIViewController(context: UIViewControllerRepresentableContext<ListVCProvider.ContainerView>) -> MainTabBarController {
                        return tabBarController
                    }
                    func updateUIViewController(_ uiViewController: ListVCProvider.ContainerView.UIViewControllerType, context: UIViewControllerRepresentableContext<ListVCProvider.ContainerView>) {
                    }
                }
            }
