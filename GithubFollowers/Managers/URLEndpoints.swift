//
//  URLEndpoints.swift
//  GithubFollowers
//
//  Created by Muhammadjon Madaminov on 24/01/25.
//

import Foundation


import Foundation

enum Endpoint {
    case user(username: String)
    case followers(username: String, perPage: Int? = 100, page: Int? = 1)

    var path: String {
        switch self {
        case .user(let username):
            return "/users/\(username)"
        case .followers(let username, _, _):
            return "/users/\(username)/followers"
        }
    }

    var queryItems: [URLQueryItem]? {
        switch self {
        case .followers(_, let perPage, let page):
            var items = [URLQueryItem]()
            if let perPage = perPage {
                items.append(URLQueryItem(name: "per_page", value: "\(perPage)"))
            }
            if let page = page {
                items.append(URLQueryItem(name: "page", value: "\(page)"))
            }
            return items.isEmpty ? nil : items
        default:
            return nil
        }
    }

    var url: URL? {
        let baseURL = "https://api.github.com"
        var components = URLComponents(string: baseURL + path)
        components?.queryItems = queryItems
        return components?.url
    }
}
