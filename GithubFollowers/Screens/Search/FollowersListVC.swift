//
//  FollowersListVC.swift
//  GithubFollowers
//
//  Created by Muhammadjon Madaminov on 23/01/25.
//

import UIKit
import SwiftUI


class FollowersListVC: UIViewController {
    
    var username: String
    var hasMoreFollers: Bool = true
    let networkManager: NetworkManagerProtocol
    let networkManagerCompletion: NetworkManagerCompletionProtocol
    var dataSource: UICollectionViewDiffableDataSource<Section, FollowersModel>?
    
    var page: Int = 1 {
        didSet {
            getFollowersCompletionHandler()
        }
    }
    var followers: [FollowersModel] = [] {
        didSet {
            updateData(followers)
        }
    }
    
    var collectionView: UICollectionView?
    var loadingView: UIView = UIView()
    
    init(username: String, networkManager: NetworkManagerProtocol = NetworkManager(), networkManagerCompletion: NetworkManagerCompletionProtocol = NetworkManagerCompletion()) {
        self.username = username
        self.networkManager = networkManager
        self.networkManagerCompletion = networkManagerCompletion
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        configureSearchBar()
        getFollowersCompletionHandler()
    }
    
    
    private func configureSearchBar() {
        let searchController = UISearchController()
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search followers..."
        searchController.searchBar.tintColor = .systemGreen
        self.navigationItem.searchController = searchController
    }
    
    
    func configure() {
        self.view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        self.title = username
        self.collectionView = createCollectionView()
        configureCollectionView()
        configureDataSource()
    }
}



//MARK: Functions
extension FollowersListVC {
    func getFollowers() {
        self.showLoadingScreen(loadingScreen: loadingView)
        Task { [weak self] in
            guard let self else { return }
            do {
                let followers = try await networkManager.fetchData(for: .followers(username: username ,page: page), type: [FollowersModel].self)
                await MainActor.run {
                    if followers.count < 100 { self.hasMoreFollers = false }
                    self.removeLoadingView(loadingView: self.loadingView)
                    self.followers.append(contentsOf: followers)
                }
            } catch {
                self.presentGFAlertOnMainThread(title: "Error", message: error.localizedDescription, buttonTitle: "Ok")
            }
        }
    }
  
    
    func getFollowersCompletionHandler() {
        self.showLoadingScreen(loadingScreen: loadingView)
        networkManagerCompletion.fetchData(for: .followers(username: username, page: page), type: [FollowersModel].self) { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success(let followers):
                DispatchQueue.main.async {
                    if followers.count < 100 { self.hasMoreFollers = false }
                    self.removeLoadingView(loadingView: self.loadingView)
                    self.followers.append(contentsOf: followers)
                }
            case .failure(let failure):
                self.presentGFAlertOnMainThread(title: "Error", message: failure.localizedDescription, buttonTitle: "Ok")
            }
        }
    }
}


extension FollowersListVC: UISearchBarDelegate, UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text, !searchText.isEmpty {
            let filteredArray = followers.filter { $0.login.lowercased().contains(searchText.lowercased()) }
            updateData(filteredArray)
        } else {
            updateData(followers)
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        updateData(followers)
    }
}


enum Section {
    case main
}




//MARK: CollectionView in FollowersListVC
extension FollowersListVC: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    
    
    func configureCollectionView() {
        guard let collectionView else { return }
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    
    func createCollectionView() -> UICollectionView {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        flowLayout.minimumLineSpacing = 5
        flowLayout.minimumInteritemSpacing = 5
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .systemBackground
        collectionView.delegate = self
        collectionView.register(FollowersCell.self, forCellWithReuseIdentifier: FollowersCell.identifier)
        return collectionView
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let numberOfCellsPerRow: CGFloat = 3 // Adjust the number of cells per row
        let padding: CGFloat = 8 // Adjust based on insets
        let minimumLineSpacing: CGFloat = 5
        
        let totalPadding = padding * (numberOfCellsPerRow + 1)
        let availableWidth = view.bounds.width - totalPadding - minimumLineSpacing*2
        let cellWidth = availableWidth / numberOfCellsPerRow
        let cellHeight = cellWidth + 40 // Add extra space for the label
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let userInfoVC = UserInfoVC()
        userInfoVC.configure(follower: followers[indexPath.row])
        self.present(userInfoVC, animated: true)
    }
    
    
    func configureDataSource() {
        guard let collectionView = collectionView else { return }
        dataSource = UICollectionViewDiffableDataSource<Section, FollowersModel>(collectionView: collectionView) { collectionView, indexPath, itemIdentifier in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FollowersCell.identifier, for: indexPath) as? FollowersCell else {
                return UICollectionViewCell()
            }
            cell.configure(follower: itemIdentifier)
            return cell
        }
    }
    
    func updateData(_ followersArray: [FollowersModel]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, FollowersModel>()
        snapshot.appendSections([.main])
        snapshot.appendItems(followersArray)
        dataSource?.apply(snapshot, animatingDifferences: true)
        if followers.isEmpty {
            self.showEmptyView(message: "This user doesn't have any followers")
        }
    }
    
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let frameHeight = scrollView.frame.height
        
        if offsetY > contentHeight - frameHeight {
            guard hasMoreFollers else { return }
            page += 1
        }
    }
}




#Preview {
    let nc = UINavigationController(rootViewController: FollowersListVC(username: "sallen0400"))
    SwiftUIPreview(vc: nc)
        .ignoresSafeArea()
}
