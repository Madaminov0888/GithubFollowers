//
//  UserInfoVC.swift
//  GithubFollowers
//
//  Created by Muhammadjon Madaminov on 06/02/25.
//

import UIKit

class UserInfoVC: UIViewController {
    
    var follower: FollowersModel?
    var user: UserModel?
    var networkManager: NetworkManagerCompletionProtocol
    
    init(networkManager: NetworkManagerCompletionProtocol = NetworkManagerCompletion()) {
        self.networkManager = networkManager
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(follower: FollowersModel) {
        self.follower = follower
        view.backgroundColor = .systemBackground
        getUserInfo(login: follower.login)
    }
    
}



extension UserInfoVC {
    func getUserInfo(login: String) {
        networkManager.fetchData(for: .user(username: login), type: UserModel.self) { result in
            switch result {
            case .success(let userInfo):
                DispatchQueue.main.async {
                    self.user = userInfo
                }
            case .failure(let error):
                self.presentGFAlertOnMainThread(title: "Error", message: error.localizedDescription, buttonTitle: "Ok")
            }
        }
    }
}
