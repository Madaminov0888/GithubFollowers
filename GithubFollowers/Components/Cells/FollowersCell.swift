//
//  FollowersCell.swift
//  GithubFollowers
//
//  Created by Muhammadjon Madaminov on 24/01/25.
//

import UIKit

class FollowersCell: UICollectionViewCell {
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func configure(follower: FollowersModel) {
        self.contentView.backgroundColor = .systemBackground
    }
    
}
