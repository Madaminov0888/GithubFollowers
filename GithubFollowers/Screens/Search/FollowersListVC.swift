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
    private let networkManager: NetworkManagerProtocol
    private let networkManagerCompletion: NetworkManagerCompletionProtocol
    var page: Int = 1
    private var followers: [FollowersModel] = []
    
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
        getFollowersCompletionHandler()
    }
    
    
    
    func configure() {
        self.view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        self.title = username
    }
    
    
    func getFollowers() {
        Task {
            do {
                let followers = try await networkManager.fetchData(for: .followers(username: username ,page: page), type: [FollowersModel].self)
                await MainActor.run {
                    self.followers.append(contentsOf: followers)
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    
    
    func getFollowersCompletionHandler() {
        networkManagerCompletion.fetchData(for: .followers(username: username, page: page), type: [FollowersModel].self) { [weak self] result in
            switch result {
            case .success(let followers):
                DispatchQueue.main.async {
                    self?.followers = followers
                }
            case .failure(let failure):
                self?.presentGFAlertOnMainThread(title: "Error", message: failure.localizedDescription, buttonTitle: "Ok")
            }
        }
    }
}



#Preview {
    let nc = UINavigationController(rootViewController: FollowersListVC(username: "lox"))
    SwiftUIPreview(vc: nc)
        .ignoresSafeArea()
}
