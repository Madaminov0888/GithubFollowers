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
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
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
    
    
    @objc func gfButtonPressed() {
        if let text = textField.text {
            navigationController?.pushViewController(FollowersListVC(username: text), animated: true)
        }
    }
}




extension SearchVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let text = textField.text {
            navigationController?.pushViewController(FollowersListVC(username: text), animated: true)
        }
        return true
    }
}




#Preview {
    SwiftUIPreview(vc: MainTabVC())
        .ignoresSafeArea()
}
