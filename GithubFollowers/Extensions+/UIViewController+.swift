//
//  UIViewController+.swift
//  GithubFollowers
//
//  Created by Muhammadjon Madaminov on 23/01/25.
//

import UIKit



extension UIViewController {
    func presentGFAlertOnMainThread(title: String, message: String, buttonTitle: String) {
        DispatchQueue.main.async {
            let alertVC = GFAlertVC(alertTitle: title, alertMessage: message, alertButtonTitle: buttonTitle)
            alertVC.modalPresentationStyle = .overFullScreen
            alertVC.modalTransitionStyle = .crossDissolve
            self.present(alertVC, animated: true)
        }
    }
    
    
    func showEmptyView(message: String? = nil) {
        DispatchQueue.main.async {
            var emptyView = GFEmptyView(frame: .zero)
            if let message { emptyView = GFEmptyView(message: message) }
            emptyView.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview(emptyView)
            
            NSLayoutConstraint.activate([
                emptyView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
                emptyView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
                emptyView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
                emptyView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            ])
        }
    }
    
    
    func showLoadingScreen(loadingScreen: UIView) {
        loadingScreen.frame = view.bounds
        view.addSubview(loadingScreen)
        
        loadingScreen.backgroundColor = UIColor.systemBackground
        loadingScreen.alpha = 0
        
        UIView.animate(withDuration: 0.25) {
            loadingScreen.alpha = 0.8
        }
        
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        loadingScreen.addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: loadingScreen.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: loadingScreen.centerYAnchor),
        ])
        
        activityIndicator.startAnimating()
    }
    
    
    func removeLoadingView(loadingView: UIView) {
        UIView.animate(withDuration: 0.25) {
            loadingView.removeFromSuperview()
        }
    }
}
