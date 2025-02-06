//
//  GFEmptyVC.swift
//  GithubFollowers
//
//  Created by Muhammadjon Madaminov on 28/01/25.
//

import UIKit

class GFEmptyView: UIView {
    
    private var textLabel = GFTextLabel(title: "This user doesn't have any followers", fontSize: 26, textAlignment: .center)
    private var logoImageView = UIImageView(frame: .zero)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configure()
    }
    
    
    init(message: String) {
        super.init(frame: .zero)
        textLabel.text = message
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        backgroundColor = .systemBackground
        configureTextLabel()
        configureLogoImage()
    }
    
    
    private func configureTextLabel() {
        addSubview(textLabel)
        textLabel.font = .systemFont(ofSize: 26, weight: .bold)
        textLabel.numberOfLines = 3
        textLabel.textColor = .secondaryLabel
        
        NSLayoutConstraint.activate([
            textLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 20),
            textLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -20),
            textLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -180),
            textLabel.heightAnchor.constraint(equalToConstant: 100)
        ])
    }
    
    private func configureLogoImage() {
        addSubview(logoImageView)
        logoImageView.image = UIImage(named: "empty-state-logo")
        logoImageView.contentMode = .scaleAspectFit
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            logoImageView.topAnchor.constraint(equalTo: textLabel.bottomAnchor, constant: 20),
            logoImageView.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -50),
            logoImageView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
    }
}




import SwiftUI
#Preview {
    UIViewPreview(view: GFEmptyView())
        .ignoresSafeArea()
}
