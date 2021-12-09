//
//  ListViewController.swift
//  Messager
//
//  Created by Сергей on 07.11.2021.
//

import UIKit

class ListViewController: UIViewController {
    
// variables
    
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
    // fake data from json files
    let activeChats = Bundle.main.decode([MessageChat].self, from: "activeChats.json")
    let waitingChats = Bundle.main.decode([MessageChat].self, from: "waitingChats.json")
    // intanse of colllection view
    var collectionView : UICollectionView!
    // diffable data sourse
    var dataSourse: UICollectionViewDiffableDataSource<Section, MessageChat>?
    private let currentUser: MessageUser
    
    
    init(currentUser: MessageUser) {
        self.currentUser = currentUser
        super.init(nibName: nil, bundle: nil)
        title = currentUser.username
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
        snapshot.appendSections([.activeChats, .waitingChats])
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
