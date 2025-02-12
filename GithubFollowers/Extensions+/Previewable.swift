//
//  Previewable.swift
//  GithubFollowers
//
//  Created by Muhammadjon Madaminov on 22/01/25.
//

import SwiftUI
import UIKit

struct SwiftUIPreview: UIViewControllerRepresentable {
    let viewController: UIViewController

    init(vc: UIViewController) {
        self.viewController = vc
    }

    func makeUIViewController(context: Context) -> UIViewController {
        return viewController
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        // No dynamic updates needed for static previews
    }
}


struct UIViewPreview: UIViewRepresentable {
    let view: UIView

    init(view: UIView) {
        self.view = view
    }

    func makeUIView(context: Context) -> UIView {
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        // No dynamic updates needed for static previews
    }
}



final class PreviewConstants {
    static let userModel: UserModel = UserModel(
        login: "testuser",
        id: 123456,
        avatarURL: "https://avatars.githubusercontent.com/u/123456?v=4",
        htmlURL: "https://github.com/testuser",
        name: "Test User",
        company: "Test Company",
        blog: "https://testuser.dev",
        location: "Test City",
        email: "testuser@example.com",
        hireable: true,
        bio: "This is a test user for GitHub API.",
        twitterUsername: "testuser",
        publicRepos: 42,
        publicGists: 10,
        followers: 100,
        following: 50,
        createdAt: "2020-01-01T00:00:00Z"
    )

}
