//
//  SearchVC+Views.swift
//  GithubFollowers
//
//  Created by Muhammadjon Madaminov on 22/01/25.
//

import Foundation
import UIKit



extension SearchVC {
    
    func setImageView() {
        self.logoImageView.image = UIImage(named: "gh-logo")
        self.logoImageView.contentMode = .scaleAspectFit
        self.logoImageView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func configureImageView() {
        self.setImageView()
        self.view.addSubview(logoImageView)
        
        NSLayoutConstraint.activate([
            logoImageView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 80),
            logoImageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            logoImageView.heightAnchor.constraint(equalToConstant: 200),
            logoImageView.heightAnchor.constraint(equalToConstant: 200),
        ])
    }
    
    
    func configureTextField() {
        self.view.addSubview(textField)
        textField.delegate = self
        
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: self.logoImageView.bottomAnchor, constant: 40),
            textField.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 50),
            textField.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -50),
            textField.heightAnchor.constraint(equalToConstant: 55),
        ])
    }
    
    
    func configureGFButton() {
        self.view.addSubview(gfButton)
        
        NSLayoutConstraint.activate([
            gfButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 40),
            gfButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -40),
            gfButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -60),
            gfButton.heightAnchor.constraint(equalToConstant: 55)
        ])
        
        gfButton.addTarget(self, action: #selector(pushFollowersListVC), for: .touchUpInside)
    }
}


