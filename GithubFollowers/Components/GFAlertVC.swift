//
//  GFAlertVC.swift
//  GithubFollowers
//
//  Created by Muhammadjon Madaminov on 23/01/25.
//

import UIKit
import SwiftUI

class GFAlertVC: UIViewController {
    
    let containerView = UIView()
    let titleLabel = GFTextLabel(fontSize: 30, textAlignment: .center)
    let messageLabel = GFTextLabel(font: .preferredFont(forTextStyle: .body), textAlignment: .center)
    let actionButton = GFButton(backgroundColor: .systemRed, title: "Ok", configuration: false)
    
    
    var alertTitle: String?
    var alertMessage: String?
    var alertButtonTitle: String?
    
    
    init(alertTitle: String? = nil, alertMessage: String? = nil, alertButtonTitle: String? = nil) {
        self.alertTitle = alertTitle
        self.alertMessage = alertMessage
        self.alertButtonTitle = alertButtonTitle
        super.init(nibName: nil, bundle: nil)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    private func configure() {
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.65)
        self.configureContainerView()
        self.configureTitleLabel()
        self.configureMessageLabel()
        self.configureActionButton()
    }
    
    
    @objc func dismissVC() {
        dismiss(animated: true)
    }
    
}




//MARK: Views
extension GFAlertVC {
    func configureContainerView() {
        self.view.addSubview(containerView)
        containerView.backgroundColor = .systemBackground
        containerView.layer.cornerRadius = 20
        containerView.layer.borderColor = UIColor.secondarySystemFill.cgColor
        containerView.layer.shadowColor = UIColor.label.cgColor
        containerView.layer.shadowOpacity = 0.2
        containerView.layer.shadowOffset = CGSize(width: 10, height: 10)
        containerView.layer.shadowRadius = 16
        containerView.layer.borderWidth = 3
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            containerView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            containerView.widthAnchor.constraint(equalToConstant: 300),
        ])
    }
    
    
    func configureTitleLabel() {
        self.containerView.addSubview(titleLabel)
        titleLabel.text = alertTitle ?? "Something went wrong"
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 30),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
        ])
    }
    
    
    func configureMessageLabel() {
        self.containerView.addSubview(messageLabel)
        messageLabel.text = alertMessage
        messageLabel.numberOfLines = 4
        
        NSLayoutConstraint.activate([
            messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30),
            messageLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            messageLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
        ])
    }
    
    func configureActionButton() {
        self.containerView.addSubview(actionButton)
        actionButton.setTitle(alertButtonTitle, for: .normal)
        actionButton.addTarget(self, action: #selector(dismissVC), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            actionButton.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 40),
            actionButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            actionButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            actionButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -20),
            
            actionButton.heightAnchor.constraint(equalToConstant: 55)
        ])
    }
}



#Preview {
    SwiftUIPreview(vc: GFAlertVC(alertTitle: "Fuck off", alertMessage: "You are being said fuck off", alertButtonTitle: "Fucking off"))
        .ignoresSafeArea()
}
