//
//  SearchVC.swift
//  GithubFollowers
//
//  Created by Muhammadjon Madaminov on 22/01/25.
//

import UIKit
import SwiftUI

class SearchVC: UIViewController {
    
    
    let logoImageView: UIImageView = UIImageView()
    let textField = GFTextField()
    let gfButton = GFButton(backgroundColor: .systemGreen, title: "Get followers")
    
    var isUsernameEntered: Bool {
        return !(textField.text?.isEmpty ?? true)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configure()
    }
    
    
    private func configure() {
        self.view.backgroundColor = .systemBackground
        self.configureImageView()
        self.configureTextField()
        self.configureGFButton()
        self.createDismissKeyboardTapGesture()
    }
    
    func createDismissKeyboardTapGesture() {
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        self.view.addGestureRecognizer(tap)
    }
    
    
    @objc func pushFollowersListVC() {
        guard self.isUsernameEntered, let text = textField.text else {
            self.presentGFAlertOnMainThread(title: "Empty username", message: "Please enter an username. And try again", buttonTitle: "Ok")
            return
        }
        let vc = FollowersListVC(username: text)
        navigationController?.pushViewController(vc, animated: true)
    }
}




extension SearchVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        pushFollowersListVC()
        return true
    }
}




#Preview {
    SwiftUIPreview(vc: MainTabVC())
        .ignoresSafeArea()
}
