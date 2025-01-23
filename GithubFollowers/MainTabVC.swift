//
//  MainTabVC.swift
//  GithubFollowers
//
//  Created by Muhammadjon Madaminov on 22/01/25.
//

import UIKit

class MainTabVC: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpTabBar()
    }
    
    func setUpTabBar() {
        let searchVC = SearchVC()
        let favouritesVC = FavouritesListVC()
        let navSearchVC = UINavigationController(rootViewController: searchVC)
        let navFavouritesVC = UINavigationController(rootViewController: favouritesVC)
        navSearchVC.tabBarItem.title = "Search"
        navSearchVC.tabBarItem.image = UIImage(systemName: "magnifyingglass")
        navFavouritesVC.tabBarItem.title = "Favourites"
        navFavouritesVC.tabBarItem.image = UIImage(systemName: "star.fill")
        
        self.tabBar.tintColor = .systemGreen
        self.setViewControllers([navSearchVC, navFavouritesVC], animated: true)
    }
}
