//
//  GFImageView.swift
//  GithubFollowers
//
//  Created by Muhammadjon Madaminov on 24/01/25.
//

import UIKit
import SwiftUI


class GFImageView: UIImageView {
    
    private let networkManager: NetworkManagerProtocol
    
    private let activityIndicator = UIActivityIndicatorView(style: .medium)
    
    private var imageURL: String?

    init(networkManager: NetworkManagerProtocol = NetworkManager(), frame: CGRect) {
        self.networkManager = networkManager
        super.init(frame: frame)
    }
    
    
    func configure(url: String) {
        self.getImage(url: url)
        translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.backgroundColor = .secondarySystemBackground
        activityIndicator.startAnimating()
        activityIndicator.hidesWhenStopped = true
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            activityIndicator.widthAnchor.constraint(equalToConstant: 100), // Optional: size it explicitly
            activityIndicator.heightAnchor.constraint(equalToConstant: 100) // Optional: size it explicitly
        ])
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func getImage(url: String) {
        self.imageURL = url
        self.image = nil
        Task {
            do {
                let image = try await networkManager.downloadImage(from: url)
                if self.imageURL == url {
                    await MainActor.run {
                        self.image = image
                        activityIndicator.stopAnimating()
                    }
                }
            } catch {
                print(error)
            }
        }
    }
}
