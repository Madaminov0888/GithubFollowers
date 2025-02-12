//
//  UserInfoVC.swift
//  GithubFollowers
//
//  Created by Muhammadjon Madaminov on 06/02/25.
//

import UIKit

final class UserInfoVC: UIViewController {
    
    var follower: FollowersModel?
    var user: UserModel? {
        didSet {
            updateViews()
        }
    }
    var networkManager: NetworkManagerCompletionProtocol
    
    var loginLabel = GFTextLabel(title: nil, fontSize: 33, textAlignment: .left)
    var nameLabel = GFTextLabel(title: nil, font: .preferredFont(forTextStyle: .headline), textAlignment: .left)
    var locationLabel = GFTextLabel(title: nil, font: .preferredFont(forTextStyle: .headline), textAlignment: .left)
    var bioLabel = GFTextLabel(title: nil, font: .preferredFont(forTextStyle: .subheadline), textAlignment: .left)
    var sinceLabel = GFTextLabel(font: .preferredFont(forTextStyle: .headline), textAlignment: .center)
    var avatarImageView = GFImageView(frame: .zero)
    
    var reposVC: UIViewController?
    var followersVC: UIViewController?
    
    init(networkManager: NetworkManagerCompletionProtocol = NetworkManagerCompletion()) {
        self.networkManager = networkManager
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureDismissButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(follower: FollowersModel) {
        self.follower = follower
        view.backgroundColor = .systemBackground
        getUserInfo(login: follower.login)
        avatarImageView.configure(url: follower.avatarURL)
        configureImageView()
        configureUserNameLabel()
        configureNameLabel()
        configureBioLabel()
    }
    
    
    private func configureDismissButton() {
        let backButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissVC))
        backButtonItem.tintColor = .systemGreen
        navigationItem.rightBarButtonItem = backButtonItem
    }
    
    
    @objc func dismissVC() {
        dismiss(animated: true)
    }
}



//MARK: View configurations
extension UserInfoVC {
    
    func updateViews() {
        guard let user else { return }
        let reposVC = GFGithubPageVC(type: .repos, user: user)
        let followerVC = GFGithubPageVC(type: .followers, user: user)
        
        self.followersVC = followerVC
        self.reposVC = reposVC
        
        avatarImageView.configure(url: user.avatarURL)
        loginLabel.text = user.login
        nameLabel.text = user.name
        locationLabel.text = user.location
        bioLabel.text = user.bio
        sinceLabel.text = "In GitHub since \(user.createdAt.formatDateString ?? "")"
        
        configureLocationLabel()
        configureReposView()
        configureFollowersView()
        configureSinceLabel()
    }
    
    
    func configureImageView() {
        let padding: CGFloat = 20
        view.addSubview(avatarImageView)
        avatarImageView.contentMode = .scaleAspectFill
        avatarImageView.layer.cornerRadius = 20
        avatarImageView.clipsToBounds = true
        
        NSLayoutConstraint.activate([
            avatarImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: padding),
            avatarImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            avatarImageView.trailingAnchor.constraint(equalTo: view.centerXAnchor, constant: -60),
            avatarImageView.heightAnchor.constraint(equalTo: avatarImageView.widthAnchor),
        ])
    }
    
    
    func configureUserNameLabel() {
        view.addSubview(loginLabel)
        loginLabel.text = user?.login
        loginLabel.textColor = .label
        
        NSLayoutConstraint.activate([
            loginLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 25),
            loginLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 20),
            loginLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
        ])
    }
    
    func configureNameLabel() {
        view.addSubview(nameLabel)
        nameLabel.text = user?.name
        nameLabel.textColor = .secondaryLabel
        
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: loginLabel.bottomAnchor, constant: 10),
            nameLabel.leadingAnchor.constraint(equalTo: loginLabel.leadingAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: loginLabel.trailingAnchor),
        ])
    }
    
    func configureLocationLabel() {
        view.addSubview(locationLabel)
        
        if let location = user?.location, !location.isEmpty {
            let imageAttachment = NSTextAttachment()
            imageAttachment.image = UIImage(systemName: "mappin.and.ellipse")?
                .withTintColor(.secondaryLabel, renderingMode: .alwaysOriginal)
            
            let imageString = NSAttributedString(attachment: imageAttachment)
            let textString = NSAttributedString(string: " \(location)", attributes: [.foregroundColor: UIColor.secondaryLabel])
            
            let fullString = NSMutableAttributedString()
            fullString.append(imageString)
            fullString.append(textString)
            
            locationLabel.attributedText = fullString
        } else {
            locationLabel.text = user?.location
        }
        locationLabel.textColor = .secondaryLabel
        
        
        NSLayoutConstraint.activate([
            locationLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10),
            locationLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            locationLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),
        ])
    }
    
    
    func configureBioLabel() {
        view.addSubview(bioLabel)
        bioLabel.textColor = .secondaryLabel
        bioLabel.numberOfLines = 3
        
        NSLayoutConstraint.activate([
            bioLabel.topAnchor.constraint(lessThanOrEqualTo: avatarImageView.bottomAnchor, constant: 20),
            bioLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            bioLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
        ])
    }
    
    
    func configureReposView() {
        guard let reposVC else { return }
        
        self.addChild(reposVC)
        self.view.addSubview(reposVC.view)
        reposVC.didMove(toParent: self)
        reposVC.view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            reposVC.view.topAnchor.constraint(equalTo: bioLabel.bottomAnchor, constant: 20),
            reposVC.view.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            reposVC.view.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            reposVC.view.heightAnchor.constraint(equalToConstant: 150),
        ])
    }
    
    func configureFollowersView() {
        guard let followersVC else { return }
        guard let reposVC else { return }
        
        self.addChild(followersVC)
        self.view.addSubview(followersVC.view)
        followersVC.didMove(toParent: self)
        followersVC.view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            followersVC.view.topAnchor.constraint(equalTo: reposVC.view.bottomAnchor, constant: 20),
            followersVC.view.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            followersVC.view.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            followersVC.view.heightAnchor.constraint(equalToConstant: 150),
        ])
    }
    
    
    func configureSinceLabel() {
        guard let followersVC else { return }
        view.addSubview(sinceLabel)
        sinceLabel.textColor = .secondaryLabel
        
        NSLayoutConstraint.activate([
            sinceLabel.topAnchor.constraint(equalTo: followersVC.view.bottomAnchor, constant: 20),
            sinceLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            sinceLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
        ])
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
