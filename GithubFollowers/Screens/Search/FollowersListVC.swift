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



#Preview {
    let nc = UINavigationController(rootViewController: FollowersListVC(username: "sallen0400"))
    SwiftUIPreview(vc: nc)
        .ignoresSafeArea()
}
