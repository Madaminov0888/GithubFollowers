//
//  FollowersModel.swift
//  GithubFollowers
//
//  Created by Muhammadjon Madaminov on 23/01/25.
//

import Foundation


struct FollowersModel: Identifiable, Codable, Hashable {
    let id: Int
    let login: String
    let avatarURL: String

    enum CodingKeys: String, CodingKey {
        case id
        case login
        case avatarURL = "avatar_url"
    }
}
