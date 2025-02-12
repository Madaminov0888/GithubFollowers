//
//  GFGithubPageVC.swift
//  GithubFollowers
//
//  Created by Muhammadjon Madaminov on 10/02/25.
//

import UIKit


enum GithubPageType {
    case repos
    case followers
}


class GFGithubPageVC: UIViewController {
    var type: GithubPageType
    var user: UserModel
    
    var leftTextLabel = GFTextLabel(font: .preferredFont(forTextStyle: .headline), textAlignment: .center)
    var leftNumericTextLabel = GFTextLabel(font: .preferredFont(forTextStyle: .headline), textAlignment: .center)
    var rightTextLabel = GFTextLabel(font: .preferredFont(forTextStyle: .headline), textAlignment: .center)
    var rightNumericTextLabel = GFTextLabel(font: .preferredFont(forTextStyle: .headline), textAlignment: .center)
    var button = GFButton(backgroundColor: .systemGreen, title: "", configuration: false)
    

    
    init(type: GithubPageType, user: UserModel) {
        self.user = user
        self.type = type
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .secondarySystemBackground
        view.layer.cornerRadius = 20
        view.clipsToBounds = true
        
        switch type {
        case .repos:
            configureRepos()
        case .followers:
            configureGithubInfo()
        }
    }
    
    func configureRepos() {
        configureLeftLabels(text: "Repositories", symbolName: "folder", num: user.publicRepos)
        configureRightLabels(text: "Public gists", symbolName: "text.alignleft", num: user.publicGists)
        configureGFButton(text: "Get Repos", color: .systemPurple, action: #selector(handleGetRepos))
    }
    
    
    func configureGithubInfo() {
        configureLeftLabels(text: "Followers", symbolName: "person.2", num: user.followers)
        configureRightLabels(text: "Following", symbolName: "heart", num: user.following)
        configureGFButton(text: "Get followers", color: .systemGreen, action: #selector(handleGetFollowers))
    }
    
    
    @objc func handleGetRepos() {
        print("get repos")
    }
    
    @objc func handleGetFollowers() {
        print("get followers")
    }
    
}



extension GFGithubPageVC {
    func configureLeftLabels(text: String, symbolName: String, num: Int) {
        view.addSubview(leftTextLabel)
        view.addSubview(leftNumericTextLabel)
        leftTextLabel.textColor = .label
        leftTextLabel.text = text
        leftTextLabel.setSymbolImage(symbolName)
        
        leftNumericTextLabel.textColor = .label
        leftNumericTextLabel.text = String(num)
        
        NSLayoutConstraint.activate([
            leftTextLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            leftTextLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            leftTextLabel.trailingAnchor.constraint(equalTo: view.centerXAnchor, constant: -20),
            
            leftNumericTextLabel.leadingAnchor.constraint(equalTo: leftTextLabel.leadingAnchor),
            leftNumericTextLabel.topAnchor.constraint(equalTo: leftTextLabel.bottomAnchor, constant: 10),
            leftNumericTextLabel.trailingAnchor.constraint(equalTo: leftTextLabel.trailingAnchor),
        ])
    }
    
    
    func configureRightLabels(text: String, symbolName: String, num: Int) {
        view.addSubview(rightTextLabel)
        view.addSubview(rightNumericTextLabel)
        rightTextLabel.textColor = .label
        rightTextLabel.text = text
        rightTextLabel.setSymbolImage(symbolName)
        
        rightNumericTextLabel.textColor = .label
        rightNumericTextLabel.text = String(num)
        
        
        NSLayoutConstraint.activate([
            rightTextLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            rightTextLabel.leadingAnchor.constraint(equalTo: view.centerXAnchor, constant: 20),
            rightTextLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            
            rightNumericTextLabel.topAnchor.constraint(equalTo: rightTextLabel.bottomAnchor, constant: 10),
            rightNumericTextLabel.leadingAnchor.constraint(equalTo: rightTextLabel.leadingAnchor),
            rightNumericTextLabel.trailingAnchor.constraint(equalTo: rightTextLabel.trailingAnchor),
        ])
   
    }
    
    
    func configureGFButton(text: String, color: UIColor, action: Selector) {
        view.addSubview(button)
        button.setTitle(text, for: .normal)
        button.setBackgroundColor(color: color, forState: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .bold)
        
        button.addTarget(self, action: action, for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: rightNumericTextLabel.bottomAnchor, constant: 20),
            button.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            button.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            button.heightAnchor.constraint(greaterThanOrEqualToConstant: 45),
        ])
    }
}



import SwiftUI
#Preview {
    SwiftUIPreview(vc: GFGithubPageVC(type: .followers, user: PreviewConstants.userModel))
        .frame(maxWidth: .infinity)
        .padding(.horizontal)
        .frame(height: 250)
}
