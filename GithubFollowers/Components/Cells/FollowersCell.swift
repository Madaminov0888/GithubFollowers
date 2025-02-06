//
//  FollowersCell.swift
//  GithubFollowers
//
//  Created by Muhammadjon Madaminov on 24/01/25.
//

import UIKit

class FollowersCell: UICollectionViewCell {
    
    static let identifier = "FollowerCell"
    private let followerImageView = GFImageView(frame: .zero)
    private let followerNameLabel = GFTextLabel(fontSize: 16, textAlignment: .center)
    private let padding: CGFloat = 8
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.followerImageView.image = nil
        self.followerNameLabel.text = nil
    }
    
    
    func configure(follower: FollowersModel) {
        self.contentView.backgroundColor = .systemBackground
        configureGFImage(url: follower.avatarURL)
        configureGFLabel(name: follower.login)
    }
    
    
    private func configureGFImage(url: String) {
        followerImageView.configure(url: url)
        self.contentView.addSubview(followerImageView)
        followerImageView.contentMode = .scaleAspectFill
        followerImageView.layer.cornerRadius = 15
        followerImageView.clipsToBounds = true
        
        NSLayoutConstraint.activate([
            followerImageView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: padding),
            followerImageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: padding),
            followerImageView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -padding),
            followerImageView.heightAnchor.constraint(equalTo: followerImageView.widthAnchor),
        ])
    }
    
    
    private func configureGFLabel(name: String) {
        followerNameLabel.text = name
        self.contentView.addSubview(followerNameLabel)
        
        NSLayoutConstraint.activate([
            followerNameLabel.topAnchor.constraint(equalTo: followerImageView.bottomAnchor, constant: padding),
            followerNameLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: padding),
            followerNameLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -padding),
            followerNameLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -10),
        ])
    }
    
    
}
